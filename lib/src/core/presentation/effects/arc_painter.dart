import 'dart:math' as math;
import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  const ArcPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.30;

    // 300° arc – gap of 60° centred at the top (i.e. gap from -120° to -60°)
    // Start angle: 120° past the top  →  -60°  =  -π/3
    // Sweep angle: 300°  =  5π/3
    const startAngle = -math.pi / 3; // 60° past 12-o'clock going CW
    const sweepAngle = 5 * math.pi / 3; // 300°

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
