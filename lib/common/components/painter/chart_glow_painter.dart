// Painter para o efeito de brilho do gráfico
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartGlowPainter extends CustomPainter {
  ChartGlowPainter({
    required this.spots,
    required this.selectedIndex,
    required this.color,
  });
  final List<FlSpot> spots;
  final int selectedIndex;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (spots.isEmpty) {
      return;
    }

    // Calcular o intervalo X e a altura do gráfico
    final double xMin = spots.map((spot) => spot.x).reduce(math.min);
    final double xMax = spots.map((spot) => spot.x).reduce(math.max);
    final double xScale = size.width / (xMax - xMin);

    final double yMin = spots.map((spot) => spot.y).reduce(math.min);
    final double yMax = spots.map((spot) => spot.y).reduce(math.max);
    final double yScale = size.height / (yMax - yMin);

    // Converter os pontos para coordenadas do canvas
    final List<Offset> points = spots.map((spot) {
      final double x = (spot.x - xMin) * xScale;
      final double y = size.height - ((spot.y - yMin) * yScale);
      return Offset(x, y);
    }).toList();

    // Destacar ponto selecionado com brilho maior
    if (selectedIndex >= 0 && selectedIndex < points.length) {
      final Paint selectedPaint = Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawCircle(
        points[selectedIndex],
        6,
        selectedPaint,
      );
    }

    // Linha com efeito de brilho
    final Paint linePaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final Path linePath = Path();

    // Verificar se existem pontos suficientes para desenhar o caminho
    if (points.length >= 2) {
      linePath.moveTo(points[0].dx, points[0].dy);

      for (int i = 1; i < points.length; i++) {
        if (i < points.length - 1) {
          final double xc = (points[i].dx + points[i + 1].dx) / 2;
          final double yc = (points[i].dy + points[i + 1].dy) / 2;
          linePath.quadraticBezierTo(points[i].dx, points[i].dy, xc, yc);
        } else {
          linePath.lineTo(points[i].dx, points[i].dy);
        }
      }

      canvas.drawPath(linePath, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant ChartGlowPainter oldDelegate) => oldDelegate.selectedIndex != selectedIndex || oldDelegate.color != color;
}
