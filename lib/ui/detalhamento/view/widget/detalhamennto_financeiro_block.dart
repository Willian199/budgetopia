import 'dart:ui';

import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/ui/detalhamento/view/widget/detalhamento_financeiro_card.dart';
import 'package:flutter/material.dart';

class DetalhamenntoFinanceiroBlock extends StatelessWidget {
  const DetalhamenntoFinanceiroBlock({
    required this.totalEntrada,
    required this.totalSaida,
    required this.totalSaldo,
    super.key,
  });

  final double totalEntrada;
  final double totalSaida;
  final double totalSaldo;

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = context.theme;
    final Size size = MediaQuery.sizeOf(context);

    // Definição de cores com base no tema atual
    final Color primaryColor = tema.colorScheme.primary;
    final Color tertiaryColor = tema.colorScheme.tertiary;

    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: tema.scaffoldBackgroundColor.withValues(alpha: 0.7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
            child: Column(
              children: [
                // Texto de cabeçalho do resumo financeiro
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: tertiaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: tertiaryColor.withValues(alpha: 0.6),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "RESUMO FINANCEIRO",
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                          color: tertiaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                DetalhamentoFinanceiroCard(
                  title: Strings.TOTAL_ENTRADAS,
                  value: totalEntrada,
                  icon: Icons.arrow_upward_rounded,
                  isHighlighted: false,
                ),
                const SizedBox(height: 16),

                DetalhamentoFinanceiroCard(
                  title: Strings.TOTAL_SAIDAS,
                  value: totalSaida,
                  icon: Icons.arrow_downward_rounded,
                  isHighlighted: false,
                ),
                const SizedBox(height: 16),
                // Bloco de saldo
                DetalhamentoFinanceiroCard(
                  isHighlighted: true,
                  title: Strings.SALDO_PERIODO,
                  value: totalSaldo,
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
