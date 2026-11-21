import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/body_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/label_text.widget.dart';

/// Standalone, animated pill toggle switch matching your app's design system.
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool? isDark;
  final bool enabled;
  final bool isLoading;
  final Color? activeColor;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.isDark,
    this.enabled = true,
    this.isLoading = false,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = isDark ?? (theme.brightness == Brightness.dark);
    final isInteractive = enabled && !isLoading && onChanged != null;
    final resolvedActiveColor = activeColor ?? AppColors.secondary;

    final trackColor = value
        ? resolvedActiveColor
        : (dark
        ? AppColors.white.withValues(alpha: 0.16)
        : AppColors.black.withValues(alpha: 0.14));

    final borderColor = value
        ? resolvedActiveColor
        : theme.colorScheme.outline.withValues(alpha: 0.45);

    return Opacity(
      opacity: (enabled && onChanged != null) ? 1.0 : 0.5,
      child: MouseRegion(
        cursor: isInteractive
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isInteractive ? () => onChanged!(!value) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: 46,
            height: 26,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: trackColor,
              border: Border.all(color: borderColor, width: 1),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: isLoading
                    ? Padding(
                  padding: const EdgeInsets.all(3),
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: resolvedActiveColor,
                  ),
                )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-width or compact toggle card matching [AppRadioButton]'s styling.
class AppSwitchTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;
  final String? subtitle;
  final IconData? leadingIcon;
  final bool? isDark;
  final bool enabled;
  final bool isLoading;
  final bool compact;

  const AppSwitchTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.subtitle,
    this.leadingIcon,
    this.isDark,
    this.enabled = true,
    this.isLoading = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = isDark ?? (theme.brightness == Brightness.dark);
    final isInteractive = enabled && !isLoading && onChanged != null;
    final activeColor = AppColors.secondary;

    final primaryTextColor = !(enabled && onChanged != null)
        ? AppColors.darkGrey
        : value
        ? activeColor
        : (dark ? AppColors.white : AppColors.black);

    final subtitleColor = dark ? AppColors.grey : AppColors.darkerGrey;

    return Opacity(
      opacity: (enabled && onChanged != null) ? 1.0 : 0.55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isInteractive ? () => onChanged!(!value) : null,
          hoverColor: activeColor.withValues(alpha: 0.05),
          splashColor: activeColor.withValues(alpha: 0.12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 16,
              vertical: compact ? 10 : 14,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: value
                    ? activeColor
                    : theme.colorScheme.outline.withValues(alpha: 0.45),
                width: value ? 1.8 : 1.0,
              ),
              color: value
                  ? activeColor.withValues(alpha: 0.08)
                  : (dark
                  ? AppColors.darkContainers.withValues(alpha: 0.5)
                  : Colors.transparent),
            ),
            child: Row(
              mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
              children: [
                if (leadingIcon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: value
                          ? activeColor.withValues(alpha: 0.14)
                          : theme.colorScheme.outline.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      leadingIcon,
                      size: 18,
                      color: value
                          ? activeColor
                          : (dark ? AppColors.white : AppColors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (compact)
                  LabelText(
                    text: label,
                    isBold: value,
                    size: 13,
                    color: primaryTextColor,
                  )
                else
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LabelText(
                          text: label,
                          isBold: value,
                          size: 13,
                          color: primaryTextColor,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 3),
                          BodyText(
                            text: subtitle!,
                            size: 11,
                            color: subtitleColor,
                          ),
                        ],
                      ],
                    ),
                  ),
                SizedBox(width: compact ? 10 : 12),
                AppSwitch(
                  value: value,
                  onChanged: onChanged,
                  isDark: dark,
                  enabled: enabled,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}