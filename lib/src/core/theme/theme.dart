import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/theme/custom_themes/appbar_theme.dart';
import 'package:smart_reload_system_admin/src/core/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:smart_reload_system_admin/src/core/theme/custom_themes/checkbox_theme.dart';
import 'package:smart_reload_system_admin/src/core/theme/custom_themes/chip_theme.dart';
import 'package:smart_reload_system_admin/src/core/theme/custom_themes/dialog_theme.dart';
import 'package:smart_reload_system_admin/src/core/theme/custom_themes/elevated_button_theme.dart';
import 'package:smart_reload_system_admin/src/core/theme/custom_themes/outline_button_theme.dart';
import 'package:smart_reload_system_admin/src/core/theme/custom_themes/text_button_theme.dart';
import 'package:smart_reload_system_admin/src/core/theme/custom_themes/text_field_theme.dart';
import 'package:smart_reload_system_admin/src/core/theme/custom_themes/text_theme.dart';
import 'package:google_fonts/google_fonts.dart';
class AppTheme{
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.softGrey,
    textTheme: GoogleFonts.interTextTheme(CTextTheme.lightTextTheme),
    elevatedButtonTheme: CElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: CAppBarTheme.lightAppBarThemeTheme,
    bottomSheetTheme: CBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: CCheckboxTheme.lightCheckboxThemeTheme,
    chipTheme: CChipTheme.lightChipThemeTheme,
    outlinedButtonTheme: COutlinedButtonTheme.lightOutlinedButtonTheme,
    textButtonTheme: CTextButtonTheme.lightTextButtonTheme,
    inputDecorationTheme: CTextFieldTheme.lightInputDecorationTheme,
    dialogTheme: CDialogTheme.lightDialogTheme,

  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.black,
    textTheme: GoogleFonts.interTextTheme(CTextTheme.darkTextTheme),
    elevatedButtonTheme: CElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: CAppBarTheme.darkAppBarThemeTheme,
    bottomSheetTheme: CBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: CCheckboxTheme.darkCheckboxThemeTheme,
    chipTheme: CChipTheme.darkChipThemeTheme,
    outlinedButtonTheme: COutlinedButtonTheme.darkOutlinedButtonTheme,
    textButtonTheme: CTextButtonTheme.darkTextButtonTheme,
    inputDecorationTheme: CTextFieldTheme.darkInputDecorationTheme,
    dialogTheme: CDialogTheme.darkDialogTheme,
  );
}
