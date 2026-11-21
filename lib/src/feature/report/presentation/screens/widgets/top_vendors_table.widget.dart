import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/utils/report_format.util.dart';
import 'package:smart_reload_system_admin/src/feature/report/domain/entity/admin_report_summary.entity.dart';
import 'package:smart_reload_system_admin/src/feature/report/presentation/screens/widgets/report_section.widget.dart';

/// Vendors ranked by sales in the period.
class TopVendorsTable extends StatelessWidget {
  const TopVendorsTable({super.key, required this.vendors});

  final List<VendorStat> vendors;

  @override
  Widget build(BuildContext context) {
    if (vendors.isEmpty) return const EmptyHint('No vendor activity in this period');

    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    Widget head(String label, {bool right = true}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Align(
            alignment: right ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              label,
              style: text.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );

    Widget cell(Widget child, {bool right = true}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Align(
            alignment: right ? Alignment.centerRight : Alignment.centerLeft,
            child: child,
          ),
        );

    Widget number(String value, {bool strong = false, Color? color}) => Text(
          value,
          style: text.bodyMedium?.copyWith(
            fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
            color: color,
          ),
        );

    return Table(
      columnWidths: const {
        0: FixedColumnWidth(36),
        1: FlexColumnWidth(2.4),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.4),
        5: FlexColumnWidth(1.5),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          children: [
            head('#', right: false),
            head('Vendor', right: false),
            head('Requests'),
            head('Sales'),
            head('Commission'),
            head('Outstanding'),
          ],
        ),
        for (var i = 0; i < vendors.length; i++)
          TableRow(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: i == vendors.length - 1
                      ? Colors.transparent
                      : cs.outlineVariant.withOpacity(0.4),
                ),
              ),
            ),
            children: [
              cell(
                Text(
                  '${i + 1}',
                  style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                right: false,
              ),
              cell(
                Text(
                  vendors[i].name,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                right: false,
              ),
              cell(number('${vendors[i].requests}')),
              cell(number(formatMoney(vendors[i].sales), strong: true)),
              cell(number(formatMoney(vendors[i].commission))),
              cell(
                number(
                  formatMoney(vendors[i].outstanding),
                  color: vendors[i].outstanding > 0 ? cs.error : cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
