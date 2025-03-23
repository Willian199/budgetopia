import 'dart:math' as math;

import 'package:flutter/material.dart';

class CyberglowPainter extends CustomPainter {
  CyberglowPainter({
    required this.color,
    this.glowIntensity = 1.0,
  });
  final Color color;
  final double glowIntensity;

  @override
  void paint(Canvas canvas, Size size) {
    // Desenhar linhas horizontais de "scanner"
    final scanPaint = Paint()
      ..color = color.withValues(alpha: 0.5 * glowIntensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i < size.height; i += 6) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        scanPaint,
      );
    }

    // Desenhar pontos de "circuito"
    final circuitPaint = Paint()
      ..color = color.withValues(alpha: 0.6 * glowIntensity)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Seed fixo para padrão consistente
    for (int i = 0; i < 10; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 1.0 + random.nextDouble() * 1.5;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        circuitPaint,
      );

      // Algumas linhas conectando os "nós"
      if (i > 0 && random.nextBool()) {
        final prevX = random.nextDouble() * size.width;
        final prevY = random.nextDouble() * size.height;

        canvas.drawLine(
          Offset(prevX, prevY),
          Offset(x, y),
          Paint()
            ..color = color.withValues(alpha: 0.3 * glowIntensity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
