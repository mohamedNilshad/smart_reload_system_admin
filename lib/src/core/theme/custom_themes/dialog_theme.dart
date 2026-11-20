import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';

class CDialogTheme{
  CDialogTheme._();

  ///light theme
  static DialogThemeData lightDialogTheme = DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Sizes.sm),
    ),
  );

  ///dark theme
  static DialogThemeData darkDialogTheme = DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Sizes.sm),
    ),
  );
}