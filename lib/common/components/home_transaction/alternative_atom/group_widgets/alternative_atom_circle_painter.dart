import 'dart:math' as math;

import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:flutter/material.dart';

class AlternativeAtomCirclePainter extends CustomPainter {
  const AlternativeAtomCirclePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AtomPunkColorPalette.cream.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw concentric circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, size.width * (i / 4), paint);
    }

    // Draw lines connecting the circles
    for (int i = 0; i < 6; i++) {
      final angle = (i / 6) * 2 * math.pi;
      final x = center.dx + (size.width / 2) * math.cos(angle);
      final y = center.dy + (size.height / 2) * math.sin(angle);

      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
