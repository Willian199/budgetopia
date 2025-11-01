import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class InfoUsuario extends StatelessWidget {
  const InfoUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AdaptiveTheme.of(context).theme;

    // Cores do tema
    final primaryColor = theme.colorScheme.primaryContainer;
    final secondaryColor = theme.colorScheme.secondary;
    final tertiaryColor = theme.colorScheme.tertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: primaryColor.withAlpha(150),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: secondaryColor.withAlpha(102),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: tertiaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: tertiaryColor.withAlpha(153),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DADOS DO USUÁRIO",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: tertiaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Preencha seus dados para personalizar seu perfil",
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodyMedium?.color,
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
