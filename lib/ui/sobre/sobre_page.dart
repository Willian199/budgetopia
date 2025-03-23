import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/button/container_back_button.dart';
import 'package:budgetopia/common/components/painter/grid_painter.dart';
import 'package:budgetopia/ui/sobre/widget/sobre_corpo.dart';
import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AdaptiveTheme.of(context).theme;
    final isDarkMode = theme.brightness == Brightness.dark;

    // Using theme colors directly from your theme files
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final tertiaryColor = theme.colorScheme.tertiary;
    final backgroundColor = isDarkMode
        ? const Color(0xFF002215) // Dark theme inputDecoratorFillColor
        : const Color(0xFFebffe5); // Light theme inputDecoratorFillColor

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Cyberpunk grid background
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                lineColor: primaryColor.withAlpha(26),
                lineWidth: 1,
              ),
            ),
          ),

          // Glowing orbs for futuristic effect
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
                    color: tertiaryColor.withAlpha(77),
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

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom Title Bar with Menu Button
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Row(
                    children: [
                      // Custom Menu Button with glow effect
                      const ContainerBackButton(),

                      Expanded(
                        child: Center(
                          // Title with cyberpunk container
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: tertiaryColor.withAlpha(128),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: tertiaryColor.withAlpha(51),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Text(
                              'BUDGETOPIA',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                                color: tertiaryColor,
                                shadows: [
                                  Shadow(
                                    color: tertiaryColor.withAlpha(179),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Balance layout with empty container
                      const SizedBox(width: 30),
                    ],
                  ),
                ),

                // Scrollable content area
                const Expanded(
                  child: SobreCorpo(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
