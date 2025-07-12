import 'package:budgetopia/common/components/home_transaction/alternative_atom/group_widgets/alternative_atom_circle_painter.dart';
import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:flutter/material.dart';

class AlternativeAtomDateCircle extends StatelessWidget {
  const AlternativeAtomDateCircle({
    required this.day,
    required this.month,
    super.key,
  });

  final int day;
  final String month;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AtomPunkColorPalette.mainGreen,
            AtomPunkColorPalette.darkGreen,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
        border: Border.all(
          color: AtomPunkColorPalette.cream.withValues(alpha: 0.2),
          width: 0,
        ),
      ),
      child: Stack(
        children: [
          // Background with concentric circles
          const Center(
            child: CustomPaint(
              painter: AlternativeAtomCirclePainter(),
              size: Size(60, 60),
            ),
          ),

          // Day and month text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AtomPunkColorPalette.cream,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: AtomPunkColorPalette.neonGreen.withValues(
                          alpha: 0.5,
                        ),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AtomPunkColorPalette.cream.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    month.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AtomPunkColorPalette.cream.withValues(alpha: 0.8),
                      letterSpacing: 1,
                    ),
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
