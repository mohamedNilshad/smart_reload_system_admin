import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/utils/report_format.util.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/admin_report_summary.entity.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/screens/widgets/report_section.widget.dart';

/// Ranked rows with a share bar: used for top packages.
class BreakdownBars extends StatelessWidget {
  const BreakdownBars({super.key, required this.items});

  final List<BreakdownItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const EmptyHint('No data in this period');

    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatMoney(item.amount),
                      style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.share.clamp(0.0, 1.0).toDouble(),
                    minHeight: 8,
                    backgroundColor: cs.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.count} ${item.count == 1 ? 'request' : 'requests'} · ${(item.share * 100).toStringAsFixed(0)}%',
                  style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Three tiles: 0–7, 8–30 and 31+ days unpaid.
class AgingSummary extends StatelessWidget {
  const AgingSummary({super.key, required this.buckets});

  final List<AgingBucket> buckets;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final colors = [cs.primary, cs.tertiary, cs.error];

    return Row(
      children: [
        for (var i = 0; i < buckets.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors[i % colors.length].withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          buckets[i].label,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      formatMoney(buckets[i].amount),
                      style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    '${buckets[i].count} unpaid',
                    style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
