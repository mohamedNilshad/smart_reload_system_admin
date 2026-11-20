import 'package:flutter/material.dart';

class CRichTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String btnLabel;
  const CRichTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.btnLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        TextButton(
          style: ButtonStyle(
              padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(0))
          ),
          onPressed: onPressed,
          child: Text(btnLabel),
        ),
      ],
    );
  }
}
