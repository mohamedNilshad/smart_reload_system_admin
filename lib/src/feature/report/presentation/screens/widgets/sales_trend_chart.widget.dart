import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/utils/report_format.util.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/admin_report_summary.entity.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/screens/widgets/report_section.widget.dart';

class SalesTrendChart extends StatelessWidget {
  const SalesTrendChart({super.key, required this.points});

  final List<TrendPoint> points;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final maxValue =
        points.fold<double>(0, (m, p) => p.amount > m ? p.amount : m);

    if (points.isEmpty || maxValue == 0) {
      return const EmptyHint('No sales in this period');
    }

    final maxY = maxValue * 1.2;
    final labelEvery = math.max(1, (points.length / 10).ceil());
    final barWidth = points.length > 40 ? 6.0 : (points.length > 20 ? 10.0 : 18.0);

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (_) => FlLine(
              color: cs.outlineVariant.withOpacity(0.4),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 54,
                interval: maxY / 4,
                getTitlesWidget: (value, meta) {
                  if (value == 0 || value > maxValue * 1.1) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      _compact(value),
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= points.length || i % labelEvery != 0) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      points[i].label,
                      style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final p = points[group.x];
                return BarTooltipItem(
                  '${p.label}\n${formatMoney(p.amount)}\n${p.count} ${p.count == 1 ? 'request' : 'requests'}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          barGroups: [
            for (var i = 0; i < points.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: points[i].amount,
                    width: barWidth,
                    color: cs.primary,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// 12500 -> "12.5K", 2300000 -> "2.3M"
  String _compact(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(v >= 10000 ? 0 : 1)}K';
    return v.toStringAsFixed(0);
  }
}
