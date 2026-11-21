import 'package:equatable/equatable.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/report_period.entity.dart';

class TrendPoint extends Equatable {
  final String label;
  final DateTime start;
  final double amount;
  final int count;

  const TrendPoint({
    required this.label,
    required this.start,
    required this.amount,
    required this.count,
  });

  @override
  List<Object?> get props => [label, start, amount, count];
}

class BreakdownItem extends Equatable {
  final String name;
  final double amount;
  final int count;

  /// Fraction of the period's total sales, 0..1.
  final double share;

  const BreakdownItem({
    required this.name,
    required this.amount,
    required this.count,
    required this.share,
  });

  @override
  List<Object?> get props => [name, amount, count, share];
}

class AgingBucket extends Equatable {
  final String label;
  final double amount;
  final int count;

  const AgingBucket({
    required this.label,
    required this.amount,
    required this.count,
  });

  @override
  List<Object?> get props => [label, amount, count];
}

class VendorStat extends Equatable {
  final String vendorId;
  final String name;
  final int requests;
  final double sales;
  final double commission;

  /// Unpaid amount for this vendor right now (not limited to the period).
  final double outstanding;

  const VendorStat({
    required this.vendorId,
    required this.name,
    required this.requests,
    required this.sales,
    required this.commission,
    required this.outstanding,
  });

  @override
  List<Object?> get props =>
      [vendorId, name, requests, sales, commission, outstanding];
}

class AdminReportSummaryEntity extends Equatable {
  final ReportPeriodEntity period;

  final double totalSales;
  final double commission;
  final int requestCount;

  /// Everything unpaid right now, regardless of the selected period.
  final double outstanding;

  /// Percent change against the previous period; null when there is nothing
  /// to compare with.
  final double? salesChangePct;
  final double? commissionChangePct;
  final double? requestsChangePct;

  final int vendorCount;
  final int clientCount;
  final int connectionCount;

  /// Vendors with at least one request in the period.
  final int activeVendors;

  /// Current commission percentage from the system settings.
  final double commissionPercent;

  final List<TrendPoint> trend;
  final List<BreakdownItem> providers;
  final List<BreakdownItem> topPackages;
  final List<VendorStat> topVendors;
  final List<AgingBucket> aging;

  const AdminReportSummaryEntity({
    required this.period,
    required this.totalSales,
    required this.commission,
    required this.requestCount,
    required this.outstanding,
    required this.salesChangePct,
    required this.commissionChangePct,
    required this.requestsChangePct,
    required this.vendorCount,
    required this.clientCount,
    required this.connectionCount,
    required this.activeVendors,
    required this.commissionPercent,
    required this.trend,
    required this.providers,
    required this.topPackages,
    required this.topVendors,
    required this.aging,
  });

  @override
  List<Object?> get props => [
        period,
        totalSales,
        commission,
        requestCount,
        outstanding,
        salesChangePct,
        commissionChangePct,
        requestsChangePct,
        vendorCount,
        clientCount,
        connectionCount,
        activeVendors,
        commissionPercent,
        trend,
        providers,
        topPackages,
        topVendors,
        aging,
      ];
}
