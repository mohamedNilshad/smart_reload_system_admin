import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';

class HeadlineText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  const HeadlineText({super.key, required this.text, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: color ?? AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }
}
