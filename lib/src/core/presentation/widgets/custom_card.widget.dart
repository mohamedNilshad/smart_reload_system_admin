import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';

class CCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final bool disableShadow;
  final Color? bgColor;
  final bool isDark;
  const CCard({super.key, required this.child, this.isDark = false, this.bgColor, this.padding, this.radius, this.margin, this.disableShadow = false});

  @override
  Widget build(BuildContext context) {
    double screenWidth = HelperFunctions.screenWidth(context);
    return Container(
      width: screenWidth/3,
      padding: padding ?? EdgeInsets.symmetric(horizontal: Sizes.md, vertical: Sizes.lg),
      margin: margin ?? EdgeInsets.symmetric(horizontal: Sizes.sm),
      decoration: BoxDecoration(
          color: bgColor ?? (isDark ? AppColors.darkContainers : AppColors.white),
          borderRadius: radius ?? BorderRadius.circular(Sizes.borderRadiusXl),
          boxShadow: disableShadow ? null : [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.15),
              spreadRadius: 2,
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
      child: child,
    );
  }
}
