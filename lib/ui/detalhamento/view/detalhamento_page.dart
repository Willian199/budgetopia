import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/button/container_back_button.dart';
import 'package:budgetopia/common/components/painter/grid_painter.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/ui/detalhamento/controller/detalhamento_controller.dart';
import 'package:budgetopia/ui/detalhamento/view/widget/detalhamennto_financeiro_block.dart';
import 'package:budgetopia/ui/detalhamento/view/widget/detalhamento_target.dart';
import 'package:budgetopia/ui/detalhamento/view/widget/grafico_dados_linha.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DetalhamentoPage extends StatefulWidget {
  const DetalhamentoPage({super.key});

  @override
  State<DetalhamentoPage> createState() => _DetalhamentoPageState();
}

class _DetalhamentoPageState extends ListenableState<DetalhamentoPage, DetalhamentoController> {
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = AdaptiveTheme.of(context).theme;
    final Size size = MediaQuery.sizeOf(context);
    final bool isDarkMode = ddi.get<bool>(qualifier: Qualifier.dark_mode);

    // Definição de cores com base no tema atual
    final Color primaryColor = tema.colorScheme.primary;
    final Color secondaryColor = tema.colorScheme.secondary;
    final Color tertiaryColor = tema.colorScheme.tertiary;
    final Color backgroundColor = isDarkMode ? const Color(0xFF002215) : const Color(0xFFebffe5);

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Grid de fundo estilo cyberpunk
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                lineColor: primaryColor.withAlpha(26),
                lineWidth: 0.8,
              ),
            ),
          ),

          // Efeito de luz superior
          Positioned(
            top: -50,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: tertiaryColor.withAlpha(51),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          // Efeito de luz inferior
          Positioned(
            bottom: -40,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: secondaryColor.withAlpha(51),
                    blurRadius: 60,
                    spreadRadius: 15,
                  ),
                ],
              ),
            ),
          ),

          // Conteúdo principal
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Saldo objetivo mensal
                    DetalhamentoTarget(valorSaldoObjetivo: listenable.valorSaldoObjetivo),

                    // Área do gráfico
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        height: 300,
                        width: size.width,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: secondaryColor.withAlpha(51),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const GraficoDadosLinha(),
                      ),
                    ),

                    // Blocos financeiros
                    DetalhamenntoFinanceiroBlock(
                      totalEntrada: listenable.value.totalEntrada,
                      totalSaida: listenable.value.totalSaida,
                      totalSaldo: listenable.value.totalSaldo,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Barra superior personalizada
          Container(
            height: 100,
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botão de menu
                const ContainerBackButton(),

                // Título
                Text(
                  Strings.DETALHES,
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
                ),

                const SizedBox(width: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
