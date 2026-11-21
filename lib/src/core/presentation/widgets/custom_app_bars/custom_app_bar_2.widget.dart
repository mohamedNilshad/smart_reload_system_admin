import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/gradient_text.widget.dart';

AppBar customAppBar({bool isDark = false, required String title, List<Widget>? action, IconData? icon, Function()? onPressed}){
  return AppBar(
    backgroundColor: isDark ? AppColors.scaffoldVendor : AppColors.white,
    leadingWidth: 20,
    shape: !isDark ? null : Border(bottom: BorderSide(
      color: AppColors.white,
      width: 0.3,
    )),
    leading: icon == null ? null : IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: isDark ? AppColors.grey : AppColors.darkerGrey, fontWeight: FontWeight.bold),
    ),
    title: InkWell(
      onTap: onPressed,
      child: GradientText(text: title),
    ),
    actions: action,
  );
}
