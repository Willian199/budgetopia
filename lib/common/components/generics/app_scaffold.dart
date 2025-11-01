import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/painter/grid_painter.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({required this.body, this.appBar, super.key});
  final Widget body;
  final Widget? appBar;

  @override
  Widget build(BuildContext context) {
    final theme = AdaptiveTheme.of(context).theme;

    // Cores do tema
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final tertiaryColor = theme.colorScheme.tertiary;
    final backgroundColor = theme.colorScheme.surface;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                lineColor: primaryColor.withAlpha(26),
                lineWidth: 0.8,
              ),
            ),
          ),

          // Efeito de luz no topo
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

          SafeArea(
            child: Column(
              children: [
                if (appBar != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: appBar!,
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
