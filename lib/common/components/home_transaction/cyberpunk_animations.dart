import 'dart:ui';

import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CyberpunkAnimations {
  // Criar uma animação de pulsação
  static Widget createPulseEffect({
    required Widget child,
    required Color color,
    double minOpacity = 0.3,
    double maxOpacity = 0.7,
    Duration duration = const Duration(seconds: 2),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: minOpacity, end: maxOpacity),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, _) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: value),
                blurRadius: 12,
                spreadRadius: 4,
              ),
            ],
          ),
          child: child,
        );
      },
      onEnd: () {}, // Adicionar lógica para reverter a animação
    );
  }

  // Criar uma animação de hover/pressionar
  static Widget createPressAnimation({
    required Widget child,
    required AnimationController controller,
    Color? glowColor,
    double scaleStart = 1.0,
    double scaleEnd = 0.97,
    Function()? onTap,
  }) {
    final Animation<double> scaleAnimation =
        Tween<double>(
          begin: scaleStart,
          end: scaleEnd,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutCubic,
          ),
        );

    final Animation<double> glowAnimation =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutCubic,
          ),
        );

    return GestureDetector(
      onTapDown: (_) => controller.forward(),
      onTapUp: (_) => controller.reverse(),
      onTapCancel: () => controller.reverse(),
      onTap: onTap,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.scale(
            scale: scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: glowColor != null
                    ? [
                        BoxShadow(
                          color: glowColor.withValues(alpha: 0.4 * glowAnimation.value),
                          blurRadius: 12 * glowAnimation.value,
                          spreadRadius: 2 * glowAnimation.value,
                        ),
                      ]
                    : null,
              ),
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }

  // Criar um efeito de fluxo de linha (parecido com eletricidade)
  static Widget createFlowLine({
    required Color color,
    double height = 1.0,
    double width = 100.0,
    Duration duration = const Duration(seconds: 2),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          height: height,
          width: width * value,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withAlpha(0),
                color.withAlpha(180),
                color.withAlpha(0),
              ],
            ),
          ),
        );
      },
    );
  }

  // Criar animação de aparecimento com fade + slide
  static Widget createFadeSlideInAnimation({
    required Widget child,
    required Animation<double> animation,
    Offset beginOffset = const Offset(0, 20),
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(
              beginOffset.dx * (1 - animation.value),
              beginOffset.dy * (1 - animation.value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Criar efeito de vidro (glassmorphism)
  static Widget createGlassContainer({
    required Widget child,
    required BuildContext context,
    Color? backgroundColor,
    Color? borderColor,
    double borderRadius = 16.0,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
    List<BoxShadow>? boxShadow,
  }) {
    final theme = context.theme;
    final isDarkMode = theme.brightness == Brightness.dark;

    final Color bgColor =
        backgroundColor ?? (isDarkMode ? Colors.black.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.2));
    final Color bdColor = borderColor ?? theme.colorScheme.secondary.withValues(alpha: 0.3);

    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: bdColor,
        ),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 1),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(borderRadius - 1),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // Criar efeito de borda neon
  static Widget createNeonBorder({
    required Widget child,
    required Color color,
    double borderWidth = 1.5,
    double borderRadius = 15.0,
    double glowIntensity = 1.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4 * glowIntensity),
            blurRadius: 6 * glowIntensity,
            spreadRadius: 1 * glowIntensity,
          ),
        ],
        border: Border.all(
          color: color.withValues(alpha: 0.8),
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }

  // Criar animação de código digital (matrix-like)
  static Widget createDigitalRain({
    required double width,
    required double height,
    Color color = Colors.green,
    Duration duration = const Duration(seconds: 10),
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: DigitalRainPainter(color: color),
      ),
    );
  }
}

// Painter para o efeito digital rain
class DigitalRainPainter extends CustomPainter {
  DigitalRainPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Implementação simplificada - linhas verticais com diferentes transparências
    for (int i = 0; i < size.width; i += 10) {
      final opacity = (i / size.width) % 0.3 + 0.1;
      paint.color = color.withValues(alpha: opacity);

      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height * (0.5 + opacity)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
