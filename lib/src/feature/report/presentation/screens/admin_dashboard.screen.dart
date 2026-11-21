import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/utils/report_format.util.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/admin_report_summary.entity.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/report_period.entity.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/bloc/admin_report.bloc.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/bloc/admin_report.event.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/bloc/admin_report.state.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/screens/widgets/kpi_card.widget.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/screens/widgets/provider_donut.widget.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/screens/widgets/report_lists.widget.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/screens/widgets/report_section.widget.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/screens/widgets/sales_trend_chart.widget.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/screens/widgets/top_vendors_table.widget.dart';

/// The admin dashboard: platform-wide sales, commission, vendors, providers
/// and unpaid requests for a chosen period.
///
/// It is a page, not a full screen: put it inside the main screen's content
/// area (no Scaffold or app bar of its own).
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  ReportPeriodEntity _period = ReportPeriodEntity.lastDays(30);

  /// Last loaded report, kept so the page doesn't blank out while refreshing.
  AdminReportSummaryEntity? _last;

  @override
  void initState() {
    super.initState();
    // The bloc is an app-level singleton: clear anything left by an earlier
    // visit, then load.
    context.read<AdminReportBloc>()
      ..add(const AdminReportReset())
      ..add(AdminReportRequested(period: _period));
  }

  void _load() {
    context.read<AdminReportBloc>().add(AdminReportRequested(period: _period));
  }

  void _pick(ReportPeriodEntity period) {
    setState(() => _period = period);
    _load();
  }

  Future<void> _pickCustom() async {
    final now = DateTime.now();
    final lastDay =
        DateTime(_period.to.year, _period.to.month, _period.to.day - 1);
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
      initialDateRange: DateTimeRange(start: _period.from, end: lastDay),
    );
    if (range == null || !mounted) return;
    _pick(ReportPeriodEntity.custom(range.start, range.end));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminReportBloc, AdminReportState>(
      listener: (context, state) {
        if (state is AdminReportFailureState && _last != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is AdminReportSuccess) _last = state.summary;
        final summary = _last;
        final isLoading =
            state is AdminReportLoading || state is AdminReportInitial;

        if (summary == null) {
          if (state is AdminReportFailureState) {
            return _ErrorView(message: state.message, onRetry: _load);
          }
          return const Center(child: CircularProgressIndicator());
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final wide = width >= 1000;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _toolbar(context, isLoading),
                  const SizedBox(height: 8),
                  _caption(context),
                  const SizedBox(height: 16),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: LinearProgressIndicator(minHeight: 3),
                    ),
                  _kpis(summary, width - 56),
                  const SizedBox(height: 20),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _leftColumn(summary)),
                        const SizedBox(width: 20),
                        Expanded(flex: 2, child: _rightColumn(summary)),
                      ],
                    )
                  else ...[
                    _leftColumn(summary),
                    const SizedBox(height: 20),
                    _rightColumn(summary),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ----------------------------------------------------------------- toolbar

  Widget _toolbar(BuildContext context, bool isLoading) {
    Widget chip(String label, VoidCallback onTap) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(label),
            selected: _period.label == label,
            showCheckmark: false,
            onSelected: (_) => onTap(),
          ),
        );

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                chip('Today', () => _pick(ReportPeriodEntity.today())),
                chip('7 days', () => _pick(ReportPeriodEntity.lastDays(7))),
                chip('30 days', () => _pick(ReportPeriodEntity.lastDays(30))),
                chip('This month', () => _pick(ReportPeriodEntity.thisMonth())),
                chip('Custom', _pickCustom),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: isLoading ? null : _load,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Refresh'),
        ),
      ],
    );
  }

  Widget _caption(BuildContext context) {
    final lastDay =
        DateTime(_period.to.year, _period.to.month, _period.to.day - 1);
    final days = _period.days;
    final range = days == 1
        ? formatDay(_period.from)
        : '${formatDay(_period.from)} – ${formatDay(lastDay)}';

    return Text(
      '$range · compared with the previous $days ${days == 1 ? 'day' : 'days'}',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }

  // -------------------------------------------------------------------- KPIs

  Widget _kpis(AdminReportSummaryEntity s, double availableWidth) {
    const gap = 16.0;
    final columns = availableWidth >= 1000 ? 4 : (availableWidth >= 600 ? 2 : 1);
    final cardWidth = (availableWidth - gap * (columns - 1)) / columns;

    final rateSet = s.commissionPercent > 0;
    final cards = <Widget>[
      KpiCard(
        label: 'Sales',
        value: formatMoney(s.totalSales),
        icon: Icons.payments_outlined,
        changePct: s.salesChangePct,
      ),
      KpiCard(
        label: rateSet
            ? 'Commission (${formatRate(s.commissionPercent)}%)'
            : 'Commission',
        value: formatMoney(s.commission),
        icon: Icons.percent_rounded,
        changePct: rateSet ? s.commissionChangePct : null,
        footnote: rateSet ? null : 'Set the rate in System settings',
      ),
      KpiCard(
        label: 'Requests',
        value: '${s.requestCount}',
        icon: Icons.receipt_long_outlined,
        changePct: s.requestsChangePct,
      ),
      KpiCard(
        label: 'Outstanding',
        value: formatMoney(s.outstanding),
        icon: Icons.hourglass_bottom_rounded,
        footnote: 'All unpaid requests',
      ),
      KpiCard(
        label: 'Vendors',
        value: '${s.vendorCount}',
        icon: Icons.storefront_outlined,
        footnote: 'Registered',
      ),
      KpiCard(
        label: 'Active vendors',
        value: '${s.activeVendors}',
        icon: Icons.trending_up_rounded,
        footnote: 'With requests in this period',
      ),
      KpiCard(
        label: 'Clients',
        value: '${s.clientCount}',
        icon: Icons.people_alt_outlined,
        footnote: 'Registered',
      ),
      KpiCard(
        label: 'Connections',
        value: '${s.connectionCount}',
        icon: Icons.cable_rounded,
        footnote: 'Across all clients',
      ),
    ];

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (final card in cards) SizedBox(width: cardWidth, child: card),
      ],
    );
  }

  // ----------------------------------------------------------------- panels

  Widget _leftColumn(AdminReportSummaryEntity s) {
    return Column(
      children: [
        ReportSection(
          title: 'Sales trend',
          subtitle: 'Hover a bar for the amount',
          child: SalesTrendChart(points: s.trend),
        ),
        const SizedBox(height: 20),
        ReportSection(
          title: 'Top vendors',
          subtitle: 'By sales in the selected period',
          child: TopVendorsTable(vendors: s.topVendors),
        ),
      ],
    );
  }

  Widget _rightColumn(AdminReportSummaryEntity s) {
    return Column(
      children: [
        ReportSection(
          title: 'Sales by service provider',
          child: ProviderDonut(items: s.providers, total: s.totalSales),
        ),
        const SizedBox(height: 20),
        ReportSection(
          title: 'Unpaid ageing',
          subtitle: 'All outstanding requests, by how old they are',
          child: AgingSummary(buckets: s.aging),
        ),
        const SizedBox(height: 20),
        ReportSection(
          title: 'Top packages',
          child: BreakdownBars(items: s.topPackages),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 44, color: cs.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
