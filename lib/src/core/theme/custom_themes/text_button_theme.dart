import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';

class CTextButtonTheme{
  CTextButtonTheme._();

  ///light theme
  static final lightTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.buttonPrimary,
      visualDensity: VisualDensity(horizontal: -4),
      textStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  ///dark theme
  static final darkTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.buttonPrimary,
      visualDensity: VisualDensity(horizontal: -4),
      textStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}