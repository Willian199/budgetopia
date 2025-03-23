import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/ui/home/model/grafico_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class LegendaInferior extends StatelessWidget {
  const LegendaInferior({
    required this.selectedSpotIndex,
    required this.value,
    required this.meta,
    required this.item,
    super.key,
  });

  final TitleMeta meta;
  final GraficoModel? item;
  final double value;
  final int selectedSpotIndex;

  @override
  Widget build(BuildContext context) {
    if (item == null || item!.legenda.isEmpty) {
      return const SizedBox();
    }
    final ThemeData tema = AdaptiveTheme.of(context).theme;
    final bool isDarkMode = ddi.get<bool>(qualifier: Qualifier.dark_mode);

    // Definição de cores
    final Color primaryColor = tema.colorScheme.primary;
    final Color tertiaryColor = tema.colorScheme.tertiary;

    // Cores adaptativas para o gráfico
    final Color corLineChart = isDarkMode ? tertiaryColor : primaryColor;

    final bool isSelected = value.toInt() == selectedSpotIndex;

    return SideTitleWidget(
      meta: meta,
      child: Column(
        children: [
          // Indicador para o mês selecionado
          isSelected
              ? Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: corLineChart,
                  ),
                )
              : const SizedBox(height: 4),

          // Texto do mês
          Text(
            item!.legenda,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
              color: corLineChart.withValues(alpha: isSelected ? 1.0 : 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
