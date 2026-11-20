
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';

class CCircularProgressIndicator extends StatelessWidget {
  final double radius;
  final Color color;
  final double rightMargin;
  const CCircularProgressIndicator({super.key, this.radius = Sizes.buttonHeight, this.rightMargin = 0, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: radius,
        width: radius,
        margin: EdgeInsets.only(right: rightMargin),
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: color),
      ),
    );
  }
}
