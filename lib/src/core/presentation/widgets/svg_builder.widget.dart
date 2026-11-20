import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CSvgBuilder extends StatelessWidget {
  final String path;
  final ColorFilter? colorFilter;
  final double? height;
  final double? width;

  const CSvgBuilder({
    super.key,
    required this.path,
    this.colorFilter,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: colorFilter,
    );
  }
}
