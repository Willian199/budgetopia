import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class SobreCorpo extends StatelessWidget {
  const SobreCorpo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AdaptiveTheme.of(context).theme;
    final isDarkMode = theme.brightness == Brightness.dark;

    // Using theme colors directly from your theme files
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final tertiaryColor = theme.colorScheme.tertiary;
    final backgroundColor = theme.colorScheme.surface;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        children: [
          // Logo with glowing effect
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withAlpha(77), // ~0.3 opacity
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
                border: Border.all(
                  color: primaryColor.withAlpha(128), // ~0.5 opacity
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: tertiaryColor.withAlpha(153), // ~0.6 opacity
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  // Icon
                  Icon(
                    Icons.account_balance_wallet,
                    size: 60,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.black.withAlpha(77) // ~0.3 opacity
                  : Colors.white.withAlpha(77), // ~0.3 opacity
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: primaryColor.withAlpha(128), // ~0.5 opacity
              ),
              boxShadow: [
                BoxShadow(
                  color: tertiaryColor.withAlpha(26), // ~0.1 opacity
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gerencie suas finanças com facilidade',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Budgetopia permite que você acompanhe suas entradas e saídas financeiras de forma simples e eficaz. Com recursos práticos e uma interface amigável, você pode manter suas finanças sob controle, alcançando seus objetivos financeiros com mais tranquilidade.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: theme.textTheme.bodyMedium?.color ?? Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? primaryColor.withAlpha(26) // ~0.1 opacity
                  : primaryColor.withAlpha(13), // ~0.05 opacity
              borderRadius: BorderRadius.circular(10),
              border: Border(
                left: BorderSide(
                  color: tertiaryColor,
                  width: 3,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: tertiaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'STATUS OPERACIONAL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: tertiaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Mantenha-se no comando das suas finanças com Budgetopia - seu parceiro confiável para uma jornada financeira mais inteligente em um mundo cada vez mais complexo.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),

          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.black.withAlpha(77) // ~0.3 opacity
                    : Colors.white.withAlpha(77), // ~0.3 opacity
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: secondaryColor.withAlpha(77), // ~0.3 opacity
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Text(
                    'v 1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: secondaryColor,
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: tertiaryColor.withAlpha(153), // ~0.6 opacity
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'ONLINE',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: tertiaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
