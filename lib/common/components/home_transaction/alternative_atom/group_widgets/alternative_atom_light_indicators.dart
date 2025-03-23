import 'package:budgetopia/common/components/home_transaction/alternative_atom/alternative_atom_group.dart';
import 'package:flutter/material.dart';

class AlternativeAtomLightIndicators extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        5,
        (index) => Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: [
              AtomPunkColorPalette.cream,
              AtomPunkColorPalette.neonGreen,
              AtomPunkColorPalette.chartreuse,
              AtomPunkColorPalette.neonGreen,
              AtomPunkColorPalette.cream
            ][index],
            boxShadow: [
              BoxShadow(
                color: [
                  AtomPunkColorPalette.cream,
                  AtomPunkColorPalette.neonGreen,
                  AtomPunkColorPalette.chartreuse,
                  AtomPunkColorPalette.neonGreen,
                  AtomPunkColorPalette.cream
                ][index]
                    .withValues(alpha: 0.6),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
