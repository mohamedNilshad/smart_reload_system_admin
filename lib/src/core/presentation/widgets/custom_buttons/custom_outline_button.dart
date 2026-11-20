import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/presentation/widgets/svg_builder.widget.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';

class COutlineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String? icon;
  final Color? fgColor;
  final Color? bgColor;
  const COutlineButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.icon,
    this.fgColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: (bgColor != null) ? WidgetStatePropertyAll(bgColor?.withValues(alpha: 0.1)) : null,
        side: (fgColor != null) ? WidgetStatePropertyAll(BorderSide(color: fgColor!)) : null,
        minimumSize: Sizes.buttonSize(
          context,
          HelperFunctions.screenWidth(context),
          Sizes.buttonHeight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          if(icon != null)...{
            CSvgBuilder(
              path: icon!,
              width: 20,
              colorFilter: ColorFilter.mode(fgColor ?? AppColors.darkerGrey, BlendMode.srcIn),
            ),
          },
          Text(
            title,
            style: TextStyle(color: fgColor),
          ),
        ],
      ),
    );
  }
}
