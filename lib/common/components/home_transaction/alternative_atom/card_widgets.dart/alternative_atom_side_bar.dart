import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:flutter/material.dart';

class AlternativeAtomSideBar extends StatelessWidget {
  const AlternativeAtomSideBar({required this.accentColor, super.key});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          7,
          (index) => Container(
            height: 8,
            width: 8,
            margin: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AtomPunkColorPalette.darkGreen,
              border: Border.all(color: accentColor.withValues(alpha: 0.7)),
            ),
          ),
        ),
      ),
    );
  }
}
