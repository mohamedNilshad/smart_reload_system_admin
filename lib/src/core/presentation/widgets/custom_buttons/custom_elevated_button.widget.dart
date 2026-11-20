import 'package:flutter/material.dart';

import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';

class CElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final bool isLoading;
  final Color? bgColor;
  final Color? fgColor;
  final Color? loadingColor;
  final double? width;
  final double? height;
  const CElevatedButton({super.key, required this.onPressed, required this.label, this.isLoading = false, this.width,this.height, this.fgColor, this.loadingColor, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? HelperFunctions.screenWidth(context), height ?? Sizes.buttonHeight),
        backgroundColor: bgColor,
      ),
      child: isLoading ? SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: loadingColor ?? Colors.white),
      ) : Text(
        label,
        style: TextStyle(
          color: fgColor,
        ),
      ),
    );
  }
}
