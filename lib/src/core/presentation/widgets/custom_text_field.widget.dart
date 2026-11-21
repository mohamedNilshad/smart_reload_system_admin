import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart' as text_formatter;
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/constants/sizes.dart';

class CTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? errorMessage;
  final bool isPassword;
  final bool readOnly;
  final bool isDark;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final int? maxLines;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final List<text_formatter.TextInputFormatter>? inputFormatters;

  const CTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.readOnly = false,
    this.isDark = false,
    this.keyboardType = TextInputType.text,
    this.errorMessage,
    this.maxLines,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.textCapitalization,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  State<CTextField> createState() => _CTextFieldState();
}

class _CTextFieldState extends State<CTextField> {
  bool obscureText = true;
  bool isDark = false;

  @override
  void initState() {
    setState(() => isDark = widget.isDark);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Sizes.xs,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: Sizes.fontSizeSm,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.darkGrey,
          ),
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: obscureText && widget.isPassword,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          style: TextStyle(
            color: isDark ? AppColors.white : null,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: (widget.errorMessage != null && widget.errorMessage!.isNotEmpty) ? widget.errorMessage : null,
            prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, size: 20) : null,
            suffixIcon: !widget.isPassword ? null : IconButton(
                onPressed: () => setState(() => obscureText = !obscureText),
                icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off)),
            iconColor: isDark ? AppColors.white : null,
            filled: widget.readOnly,
            fillColor: isDark ? (widget.readOnly ? AppColors.darkerGrey : null) : (widget.readOnly ? Colors.grey[100] : null),

          ),
        ),
      ],
    );
  }
}