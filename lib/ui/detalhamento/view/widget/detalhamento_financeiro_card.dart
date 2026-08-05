import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:flutter/material.dart';

class DetalhamentoFinanceiroCard extends StatelessWidget {
  const DetalhamentoFinanceiroCard({
    required this.isHighlighted,
    required this.title,
    required this.value,
    required this.icon,
    super.key,
  });

  final bool isHighlighted;
  final String title;
  final double value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = context.theme;

    // Definição de cores com base no tema atual
    final Color primaryColor = tema.colorScheme.primary;
    final Color tertiaryColor = tema.colorScheme.tertiary;

    final Color cardColor = tema.scaffoldBackgroundColor;
    final Color iconColor = isHighlighted ? tertiaryColor : primaryColor;

    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isHighlighted ? tertiaryColor.withValues(alpha: 0.15) : primaryColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isHighlighted ? tertiaryColor.withValues(alpha: 0.3) : primaryColor.withValues(alpha: 0.2),
          width: isHighlighted ? 1.2 : 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // Ícone
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Texto e valor
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${Strings.RS} ${Moeda.format(valor: value)}",
                    style: TextStyle(
                      fontSize: isHighlighted ? 18 : 16,
                      fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                      color: isHighlighted ? tertiaryColor : null,
                    ),
                  ),
                ],
              ),
            ),

            // Indicador visual
            Container(
              width: 2,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    iconColor.withValues(alpha: 0),
                    iconColor.withValues(alpha: 0.5),
                    iconColor.withValues(alpha: 0),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
