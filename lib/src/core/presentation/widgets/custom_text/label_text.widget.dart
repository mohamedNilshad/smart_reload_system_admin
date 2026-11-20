import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';

class LabelText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? size;
  final bool isBold;
  const LabelText({super.key, required this.text, this.color, this.overflow, this.maxLines = 1, this.size, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: color ?? AppColors.black,
        fontSize: size,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        overflow: overflow,
      ),
    );
  }
}
