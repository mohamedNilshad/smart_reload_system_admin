import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color? color;
  final bool isBold;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  const TitleText({super.key, required this.text, this.color, this.overflow, this.maxLines = 1, this.isBold = true, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: color ?? AppColors.black,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        overflow: overflow,
      ),
      textAlign: textAlign,
    );
  }
}
