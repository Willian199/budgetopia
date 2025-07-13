import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:flutter/material.dart';

class AlternativeAtomStatusIndicator extends StatelessWidget {
  const AlternativeAtomStatusIndicator({required this.isCompleted, super.key});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isCompleted ? AtomPunkColorPalette.neonGreen : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AtomPunkColorPalette.mainGreen,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AtomPunkColorPalette.cream.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicator light
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.6),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          // Status text
          Text(
            isCompleted ? 'OK' : 'PEND',
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: AtomPunkColorPalette.cream,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
