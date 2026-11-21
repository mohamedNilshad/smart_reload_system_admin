import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/utils/report_format.util.dart';

class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.changePct,
    this.footnote,
  });

  final String label;
  final String value;
  final IconData icon;

  /// Percent change vs the previous period. When null, [footnote] is shown.
  final double? changePct;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 19, color: cs.onPrimaryContainer),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelLarge?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 8),
          _buildChange(context),
        ],
      ),
    );
  }

  Widget _buildChange(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final small = Theme.of(context).textTheme.bodySmall;
    final pct = changePct;

    if (pct == null) {
      return Text(
        footnote ?? 'No prior data',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: small?.copyWith(color: cs.onSurfaceVariant),
      );
    }

    final up = pct >= 0;
    final color = up ? Colors.green.shade700 : cs.error;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 2),
        Text(
          '${formatPct(pct)} vs previous',
          style: small?.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
