import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';

class BodyText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? size;
  final bool isBold;
  final TextAlign? textAlign;
  const BodyText({super.key, required this.text, this.color, this.overflow, this.maxLines, this.size, this.isBold = false, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: color ?? AppColors.black,
        overflow: overflow,
        fontWeight: isBold ? FontWeight.bold : null,
        fontSize: size,
      ),
      textAlign: textAlign,
    );
  }
}
