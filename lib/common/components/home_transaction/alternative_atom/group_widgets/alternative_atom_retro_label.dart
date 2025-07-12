import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:flutter/material.dart';

class AtompunkRetroLabel extends StatelessWidget {
  const AtompunkRetroLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AtomPunkColorPalette.mainGreen,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: AtomPunkColorPalette.cream.withValues(alpha: 0.3),
        ),
      ),
      child: const Text(
        "TRANSAÇÕES",
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: AtomPunkColorPalette.cream,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
