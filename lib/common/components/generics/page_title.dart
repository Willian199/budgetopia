import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = AdaptiveTheme.of(context).theme;

    final primaryColor = theme.colorScheme.primary;
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 3,
        color: primaryColor,
        shadows: [
          Shadow(
            color: primaryColor.withAlpha(128),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}
