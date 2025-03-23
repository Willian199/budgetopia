// cyberpunk_background.dart
import 'package:budgetopia/common/components/painter/grid_painter.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;

    final Color primaryColor = theme.colorScheme.primary;
    final Color secondaryColor = theme.colorScheme.secondary;
    final Color tertiaryColor = theme.colorScheme.tertiary;

    return Stack(
      children: [
        // Grid de fundo cyberpunk
        Positioned.fill(
          child: CustomPaint(
            painter: GridPainter(
              lineColor: primaryColor.withAlpha(26),
              lineWidth: 0.8,
            ),
          ),
        ),

        // Orbes de luz para efeito futurista
        Positioned(
          top: -50,
          right: -30,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: tertiaryColor.withAlpha(51),
                  blurRadius: 80,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: -40,
          left: -20,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: secondaryColor.withAlpha(77),
                  blurRadius: 60,
                  spreadRadius: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
