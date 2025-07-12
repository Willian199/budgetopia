import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:flutter/material.dart';

class AlternativeAtomScannerLine extends StatelessWidget {
  const AlternativeAtomScannerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: Row(
        children: List.generate(
          20,
          (index) => Container(
            width: (index % 3 == 0) ? 6.0 : 12.0,
            height: 1,
            color: AtomPunkColorPalette.cream.withValues(
              alpha: (index % 2 == 0) ? 0.4 : 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
