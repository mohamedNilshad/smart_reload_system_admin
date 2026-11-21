import 'package:smart_reload_system_admin/src/feature/report/domain/entity/admin_report_row.entity.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/admin_report_summary.entity.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/report_period.entity.dart';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

enum _Granularity { day, week, month }

/// Pure Dart: turns the rows loaded from Firestore into everything the admin
/// dashboard shows. No Firebase, no Flutter, so it is easy to unit test.
class AdminReportCalculator {
  const AdminReportCalculator();

  /// How many slices the provider donut shows; the rest become "Others".
  static const _maxProviders = 6;

  AdminReportSummaryEntity build({
    required AdminReportSourceEntity source,
    required ReportPeriodEntity period,
    required DateTime now,
  }) {
    final rows = source.rows;
    final rate = source.commissionPercent;

    final current = rows
        .where((r) =>
            !r.requestDate.isBefore(period.from) &&
            r.requestDate.isBefore(period.to))
        .toList();
    final previous = rows
        .where((r) =>
            !r.requestDate.isBefore(period.previousFrom) &&
            r.requestDate.isBefore(period.from))
        .toList();
    final unpaid = rows.where((r) => !r.isPaid).toList();

    final sales = _sum(current);
    final prevSales = _sum(previous);
    final commission = _commission(current, rate);
    final prevCommission = _commission(previous, rate);

    return AdminReportSummaryEntity(
      period: period,
      totalSales: sales,
      commission: commission,
      requestCount: current.length,
      outstanding: _sum(unpaid),
      salesChangePct: _pct(sales, prevSales),
      commissionChangePct: _pct(commission, prevCommission),
      requestsChangePct:
          _pct(current.length.toDouble(), previous.length.toDouble()),
      vendorCount: source.vendorCount,
      clientCount: source.clientCount,
      connectionCount: source.connectionCount,
      activeVendors: current.map((r) => r.vendorId).toSet().length,
      commissionPercent: rate,
      trend: _trend(current, period),
      providers: _providers(current, sales),
      topPackages: _breakdown(current, (r) => r.packageName, sales, limit: 5),
      topVendors: _topVendors(current, unpaid, source.vendorNames, rate),
      aging: _aging(unpaid, now),
    );
  }

  // ----------------------------------------------------------------- helpers

  double _sum(Iterable<AdminReportRowEntity> rows) =>
      rows.fold<double>(0, (s, r) => s + r.amount);

  double _commission(Iterable<AdminReportRowEntity> rows, double rate) =>
      rows.fold<double>(
        0,
        (s, r) => s + r.amount * (r.commissionPercent ?? rate) / 100,
      );

  double? _pct(double current, double previous) =>
      previous == 0 ? null : (current - previous) / previous * 100;

  int _dayDiff(DateTime a, DateTime b) =>
      DateTime.utc(b.year, b.month, b.day)
          .difference(DateTime.utc(a.year, a.month, a.day))
          .inDays;

  // ------------------------------------------------------------------- trend

  List<TrendPoint> _trend(List<AdminReportRowEntity> rows, ReportPeriodEntity p) {
    final g = p.days <= 31
        ? _Granularity.day
        : p.days <= 120
            ? _Granularity.week
            : _Granularity.month;

    DateTime bucketStart(DateTime d) => switch (g) {
          _Granularity.day => DateTime(d.year, d.month, d.day),
          _Granularity.week => DateTime(d.year, d.month, d.day - (d.weekday - 1)),
          _Granularity.month => DateTime(d.year, d.month),
        };

    DateTime nextBucket(DateTime s) => switch (g) {
          _Granularity.day => DateTime(s.year, s.month, s.day + 1),
          _Granularity.week => DateTime(s.year, s.month, s.day + 7),
          _Granularity.month => DateTime(s.year, s.month + 1),
        };

    String label(DateTime d) => g == _Granularity.month
        ? _months[d.month - 1]
        : '${d.day} ${_months[d.month - 1]}';

    // Pre-create every bucket so quiet days still show as empty bars.
    final amounts = <DateTime, double>{};
    final counts = <DateTime, int>{};
    for (var s = bucketStart(p.from); s.isBefore(p.to); s = nextBucket(s)) {
      amounts[s] = 0;
      counts[s] = 0;
    }
    for (final r in rows) {
      final key = bucketStart(r.requestDate);
      if (amounts.containsKey(key)) {
        amounts[key] = amounts[key]! + r.amount;
        counts[key] = counts[key]! + 1;
      }
    }

    return [
      for (final key in amounts.keys)
        TrendPoint(
          label: label(key),
          start: key,
          amount: amounts[key]!,
          count: counts[key]!,
        ),
    ];
  }

  // --------------------------------------------------------------- breakdown

  List<BreakdownItem> _breakdown(
    List<AdminReportRowEntity> rows,
    String Function(AdminReportRowEntity) keyOf,
    double total, {
    int? limit,
  }) {
    final amounts = <String, double>{};
    final counts = <String, int>{};
    for (final r in rows) {
      final k = keyOf(r);
      amounts[k] = (amounts[k] ?? 0) + r.amount;
      counts[k] = (counts[k] ?? 0) + 1;
    }

    final items = [
      for (final k in amounts.keys)
        BreakdownItem(
          name: k,
          amount: amounts[k]!,
          count: counts[k]!,
          share: total == 0 ? 0 : amounts[k]! / total,
        ),
    ]..sort((a, b) => b.amount.compareTo(a.amount));

    return limit == null || items.length <= limit
        ? items
        : items.sublist(0, limit);
  }

  /// Sales by service provider; the smallest ones are merged into "Others".
  List<BreakdownItem> _providers(List<AdminReportRowEntity> rows, double total) {
    final all = _breakdown(rows, (r) => r.provider, total);
    if (all.length <= _maxProviders) return all;

    final head = all.sublist(0, _maxProviders - 1);
    final tail = all.sublist(_maxProviders - 1);
    final amount = tail.fold<double>(0, (s, i) => s + i.amount);
    final count = tail.fold<int>(0, (s, i) => s + i.count);
    return [
      ...head,
      BreakdownItem(
        name: 'Others',
        amount: amount,
        count: count,
        share: total == 0 ? 0 : amount / total,
      ),
    ];
  }

  // ------------------------------------------------------------------ vendors

  List<VendorStat> _topVendors(
    List<AdminReportRowEntity> current,
    List<AdminReportRowEntity> unpaid,
    Map<String, String> names,
    double rate,
  ) {
    final byVendor = <String, List<AdminReportRowEntity>>{};
    for (final r in current) {
      byVendor.putIfAbsent(r.vendorId, () => []).add(r);
    }

    final outstandingByVendor = <String, double>{};
    for (final r in unpaid) {
      outstandingByVendor[r.vendorId] =
          (outstandingByVendor[r.vendorId] ?? 0) + r.amount;
    }

    final stats = [
      for (final e in byVendor.entries)
        VendorStat(
          vendorId: e.key,
          name: names[e.key] ?? 'Unknown vendor',
          requests: e.value.length,
          sales: _sum(e.value),
          commission: _commission(e.value, rate),
          outstanding: outstandingByVendor[e.key] ?? 0,
        ),
    ]..sort((a, b) => b.sales.compareTo(a.sales));

    return stats.take(5).toList();
  }

  // ------------------------------------------------------------------ ageing

  List<AgingBucket> _aging(List<AdminReportRowEntity> unpaid, DateTime now) {
    final amounts = [0.0, 0.0, 0.0];
    final counts = [0, 0, 0];
    for (final r in unpaid) {
      final age = _dayDiff(r.requestDate, now);
      final i = age <= 7 ? 0 : (age <= 30 ? 1 : 2);
      amounts[i] += r.amount;
      counts[i] += 1;
    }
    const labels = ['0–7 days', '8–30 days', '31+ days'];
    return [
      for (var i = 0; i < 3; i++)
        AgingBucket(label: labels[i], amount: amounts[i], count: counts[i]),
    ];
  }
}
