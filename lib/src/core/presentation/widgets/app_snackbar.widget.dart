import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';

enum _SnackType { success, error, info }

class AppSnackbar {
  AppSnackbar._();

  static void showSuccess(BuildContext context, String message, {bool showUp = false}) {
    _show(context, message, _SnackType.success, showUp);
  }

  static void showError(BuildContext context, String message, {bool showUp = false}) {
    _show(context, message, _SnackType.error, showUp);
  }

  static void showInfo(BuildContext context, String message, {bool showUp = false}) {
    _show(context, message, _SnackType.info, showUp);
  }

  static void _show(BuildContext context, String message, _SnackType type, bool showUp) {
    final isSuccess = (type == _SnackType.success);
    final isError = (type == _SnackType.error);
    // final isInfo = (type == _SnackType.info);

    final accent = isSuccess ? AppColors.green : (isError ? AppColors.red : AppColors.info);
    final icon = isSuccess ? Icons.check_rounded : (isError ? Icons.close_rounded : Icons.info_outline_rounded);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 5),
          margin: showUp ? EdgeInsets.only(
            bottom: HelperFunctions.screenHeight(context) - 160,
            left: 16,
            right: 16,
          ) : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.zero,
          content: _SnackbarContent(message: message, accent: accent, icon: icon),
        ),
      );
  }
}

class _SnackbarContent extends StatelessWidget {
  final String message;
  final Color accent;
  final IconData icon;

  const _SnackbarContent({
    required this.message,
    required this.accent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkerGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: accent, width: 6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}