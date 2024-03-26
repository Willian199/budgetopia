import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class CardSeparador extends StatelessWidget {
  const CardSeparador({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = AdaptiveTheme.of(context).theme.colorScheme;

    return Container(
      height: 55,
      width: 2,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }
}
