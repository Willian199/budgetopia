import 'package:flutter/material.dart';

class GradientBoxShadow {
  GradientBoxShadow({
    required this.gradient,
    this.borderRadius,
    this.blurRadius = 0,
    this.offset = Offset.zero,
    this.spreadRadius = 0,
  });
  final BorderRadius? borderRadius;
  final double blurRadius;
  final Gradient gradient;
  final Offset offset;
  final double spreadRadius;
}

class GradientRect extends StatelessWidget {
  const GradientRect({required this.boxShadow, super.key, this.child});

  final Widget? child;
  final GradientBoxShadow boxShadow;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GradientBoxShadowPainter(boxShadow),
      child: child,
    );
  }
}

class GradientBoxShadowPainter extends CustomPainter {
  GradientBoxShadowPainter(this.boxShadow);
  final GradientBoxShadow boxShadow;

  @override
  void paint(Canvas canvas, Size size) {
    final canvasRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final canvasRRect = boxShadow.borderRadius?.toRRect(canvasRect);

    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: boxShadow.gradient.colors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(canvasRect)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, boxShadow.blurRadius);

    // Calcula o raio para o efeito de espalhamento
    final double spreadRadius = (boxShadow.spreadRadius + boxShadow.blurRadius);

    if (canvasRRect != null) {
      // Desenha o gradiente
      canvas.drawRRect(canvasRRect.inflate(spreadRadius).shift(Offset(boxShadow.offset.dx, boxShadow.offset.dy)), paint);
    } else {
      // Desenha o gradiente
      canvas.drawRect(canvasRect.inflate(spreadRadius).shift(Offset(boxShadow.offset.dx, boxShadow.offset.dy)), paint);
    }
  }

  @override
  bool shouldRepaint(GradientBoxShadowPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(GradientBoxShadowPainter oldDelegate) => false;
}
