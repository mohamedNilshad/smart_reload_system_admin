import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const GradientText({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return AppColors.linerGradient.createShader(bounds);
      },
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }
}
