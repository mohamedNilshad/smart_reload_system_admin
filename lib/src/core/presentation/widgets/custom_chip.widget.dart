import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/sub_title_text.widget.dart';

class CChip extends StatelessWidget {
  final Color? bgColor;
  final Color? fontColor;
  final String label;
  final bool enableStatus;
  final Color? statusColor;
  final double? statusRadius;
  final double? borderRadius;
  final double? horizontalPadding;
  final double? verticalPadding;

  const CChip({
    super.key,
    this.bgColor,
    this.fontColor,
    required this.label,
    this.enableStatus = false,
    this.statusColor,
    this.statusRadius = 4.0,
    this.borderRadius = 15,
    this.verticalPadding = 2,
    this.horizontalPadding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding!, vertical: verticalPadding!),
      // alignment: Alignment.center,
      width: label.length > 10 ? 110 : null,
      decoration: BoxDecoration(
        color: (bgColor ?? AppColors.grey).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(borderRadius!),
      ),
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(enableStatus)...{
            CircleAvatar(
              radius: statusRadius,
              backgroundColor: statusColor ?? AppColors.buttonGreen,
            ),
          },

          SubTitleText(
            text: label,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            color: fontColor ?? AppColors.darkerGrey,
          ),
        ],
      ),
    );
  }
}
