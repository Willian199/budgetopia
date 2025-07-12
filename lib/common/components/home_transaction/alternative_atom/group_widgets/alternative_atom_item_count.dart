import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:flutter/material.dart';

class AlternativeAtomItemCount extends StatelessWidget {
  const AlternativeAtomItemCount({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AtomPunkColorPalette.darkGreen,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: AtomPunkColorPalette.neonGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        "$count ${count == 1 ? 'ITEM' : 'ITENS'}",
        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: AtomPunkColorPalette.neonGreen,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
