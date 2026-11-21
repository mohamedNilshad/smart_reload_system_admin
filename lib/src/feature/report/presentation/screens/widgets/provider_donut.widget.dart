import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/admin_report_summary.entity.dart';
import 'package:smart_reload_system_admin/src/core/utils/report_format.util.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/screens/widgets/report_section.widget.dart';

const _palette = [
  Color(0xFF1E5EFF),
  Color(0xFF00B8A9),
  Color(0xFFF6B93B),
  Color(0xFFE55039),
  Color(0xFF8E44AD),
  Color(0xFF7F8C8D),
];

/// Donut chart of sales by service provider, with a legend underneath.
class ProviderDonut extends StatelessWidget {
  const ProviderDonut({super.key, required this.items, required this.total});

  final List<BreakdownItem> items;
  final double total;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty || total == 0) {
      return const EmptyHint('No sales in this period');
    }

    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        SizedBox(
          height: 190,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 62,
                  sections: [
                    for (var i = 0; i < items.length; i++)
                      PieChartSectionData(
                        value: items[i].amount,
                        color: _palette[i % _palette.length],
                        radius: 26,
                        showTitle: false,
                      ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total sales',
                    style: text.labelMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 100,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        formatMoney(total),
                        style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _palette[i % _palette.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    items[i].name,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodyMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatMoney(items[i].amount),
                  style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: 46,
                  child: Text(
                    '${(items[i].share * 100).toStringAsFixed(0)}%',
                    textAlign: TextAlign.right,
                    style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
