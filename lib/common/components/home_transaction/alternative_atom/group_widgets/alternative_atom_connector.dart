import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:flutter/material.dart';

class AlternativeAtomConnector extends StatelessWidget {
  const AlternativeAtomConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 20,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AtomPunkColorPalette.neonGreen.withValues(alpha: 0.7),
            AtomPunkColorPalette.neonGreen.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}
