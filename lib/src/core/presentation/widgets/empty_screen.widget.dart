import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/image_strings.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/custom_text/title_text.widget.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/gif_builder.widget.dart';

class EmptyScreenWidget extends StatelessWidget {
  final String message;
  final bool isDark;
  final EdgeInsetsGeometry? padding;

  const EmptyScreenWidget({super.key, this.message = "No results found", this.isDark = false, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            GifBuilder(url: isDark ? ImageStrings.emptyScreenDark : ImageStrings.emptyScreen, isDark: isDark),

            TitleText(
              text: message,
              isBold: false,
              color: isDark ? AppColors.grey : AppColors.darkerGrey,
            ),
          ],
        ),
      ),
    );
  }
}