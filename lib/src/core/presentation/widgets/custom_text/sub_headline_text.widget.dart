import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';

class SubHeadlineText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final bool isVendor;
  const SubHeadlineText({super.key, required this.text, this.color, this.size, this.isVendor = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: color ?? (isVendor ? AppColors.white : AppColors.black),
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }
}
