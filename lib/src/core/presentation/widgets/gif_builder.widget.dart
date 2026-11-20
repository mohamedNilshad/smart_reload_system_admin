import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';

class GifBuilder extends StatelessWidget {
  final String url;
  final bool isDark;
  const GifBuilder({super.key, required this.url, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      url,
      width: 80,
      height: 80,
      color: isDark ? null : AppColors.softGrey,
      colorBlendMode: isDark ? null : BlendMode.multiply,
    );
  }
}
