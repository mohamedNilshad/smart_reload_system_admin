import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /// App Basic Colors
  static const Color primary = Color(0xFF4361EE);
  static const Color secondary = Color(0xff5e66e0);
  static const Color accent = Color(0xFFFFB200);

  static const Color scaffoldVendor = Color(0xFF232323);
  static const Color bottomNavVendor = Color(0xFF020B22);

  ///Gradient Colors
  static const Gradient linerGradient =  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4A90E2), // Blue
      Color(0xFF9B59B6), // Purple
    ],
  );

// ── Text ─────────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1C1D22); // near-black with a cool tint
  static const Color textSecondary = Color(0xFF616577); // blue-grey instead of green-grey
  static const Color textWhite     = AppColors.white;

// ── Icons ────────────────────────────────────────────────────────────────────
  static const Color selectedIcon       = AppColors.primary;
  static const Color lightUnSelectedIcon = AppColors.darkerGrey;
  static const Color darkUnSelectedIcon  = AppColors.softGrey;

// ── Backgrounds ──────────────────────────────────────────────────────────────
  static const Color light             = Color(0xFFF7F8FA); // cool-white, not warm beige
  static const Color dark              = Color(0xFF1E1F26); // deep navy-charcoal
  static const Color primaryBackground = Color(0xFFEEF1FC); // softer blue tint

// ── Container Backgrounds ────────────────────────────────────────────────────
  static const Color lightContainers = Color(0xFFF2F3F7);
  static Color       darkContainers  = const Color(0xFF40404E); // explicit instead of withAlpha hack
  static const Color darkTabBg       = Color(0xFF302034);       // kept — it works well
  static const Color selectedTabColor = Color(0xFFE8ECFA);

// ── Buttons ──────────────────────────────────────────────────────────────────
  static const Color buttonPrimary   = Color(0xFF4361EE);
  static const Color buttonGreen     = Color(0xFF0EA66B); // more vivid, less muddy
  static const Color buttonSecondary = Color(0xFF6B7280);
  static const Color buttonDisabled  = Color(0xFFC4C9D4); // cool-grey, not warm-ash

// ── Borders ──────────────────────────────────────────────────────────────────
  static const Color borderPrimary   = Color(0xFF16171C);
  static const Color borderSecondary = Color(0xFFE2E5EE); // slight blue tint
  static const Color borderGrey      = Color(0xFFEAECF2);

// ── Status ───────────────────────────────────────────────────────────────────
  static const Color error   = Color(0xFFC62828); // deeper red, more serious
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFE65100); // burnt orange, clearer than amber
  static const Color info    = Color(0xFF1565C0);

// ── Neutrals ─────────────────────────────────────────────────────────────────
  static const Color black      = Color(0xFF1C1D22);
  static const Color shadowColor = Colors.black12;
  static const Color darkerGrey = Color(0xFF4A4D5C); // cooler, matches text family
  static const Color darkGrey   = Color(0xFF9195A3);
  static const Color grey       = Color(0xFFE0E3EB);
  static const Color softGrey   = Color(0xFFF2F3F7);
  static const Color lightGrey  = Color(0xFFF9FAFB);
  static const Color white      = Color(0xFFFFFFFF);

// ── Shimmer ──────────────────────────────────────────────────────────────────
  static const Color baseColorLight  = Color(0xFFDDE0E8);
  static const Color baseColorDark   = Color(0xFF6B6F7E);
  static const Color highlightColor  = Color(0xFFF4F5F8);

// ── Other ────────────────────────────────────────────────────────────────────
  static const Color purple = Color(0xFF9B59B6);
  static const Color red = Color(0xFFD2042D);
  static const Color green = Color(0xFF1DAA23);
  static const Color avatar = Color(0xFFBD8B31);

}