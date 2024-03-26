import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/pages/home/model/grafico_model.dart';
import 'package:budgetopia/common/components/grafico/legenda_esquerda.dart';
import 'package:budgetopia/common/components/grafico/legenda_inferior.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class GraficoLinha extends StatelessWidget {
  GraficoLinha({
    super.key,
  });

  final List<GraficoModel> values = GraficoModel.values;

  final AxisTitles empty = const AxisTitles();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = AdaptiveTheme.of(context).theme.colorScheme;
    final Color corBack = ddi.get<bool>(qualifier: Qualifier.dark_mode) ? colorScheme.primary : colorScheme.onPrimary;

    final List<FlSpot> allSpots = values.map((GraficoModel item) => FlSpot(item.index, item.valor)).toList();

    return SafeArea(
      right: false,
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return LineChart(
          LineChartData(
            minY: 0,
            minX: values.length > 8 ? 1.5 : 1,
            backgroundColor: AdaptiveTheme.of(context).theme.appBarTheme.backgroundColor!,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                final int tamanho = values.length;

                return spotIndexes.map((int index) {
                  return TouchedSpotIndicatorData(
                    //Cor da linha vertical
                    const FlLine(color: Colors.transparent, strokeWidth: 20),
                    //Bolinha ao selecionar o item no gráfico
                    FlDotData(
                      show: (index > (tamanho > 8 ? 1 : 0)) && (index < (tamanho - 1)),
                      getDotPainter: (FlSpot spot, double percent, LineChartBarData barData, int index) {
                        return FlDotCirclePainter(
                          radius: 8,
                          color: AdaptiveTheme.of(context).theme.colorScheme.primary,
                          strokeWidth: 3,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  );
                }).toList();
              },
              //Campo do valor ao clicar no gráfico
              touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                showOnTopOfTheChartBoxArea: true,
                tooltipBgColor: Colors.green,
                tooltipRoundedRadius: 8,
                getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                  return lineBarsSpot.map((LineBarSpot lineBarSpot) {
                    return LineTooltipItem(
                      Moeda.ajustarMoeda(
                        valor: lineBarSpot.y,
                        simbolo: 'R\$',
                      ),
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: <LineChartBarData>[
              LineChartBarData(
                spots: allSpots,
                isCurved: true,
                barWidth: 4,
                shadow: const Shadow(
                  blurRadius: 8,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: corBack,
                ),
                aboveBarData: BarAreaData(
                  show: true,
                  color: AdaptiveTheme.of(context).theme.appBarTheme.backgroundColor!,
                ),
                dotData: FlDotData(
                  checkToShowDot: (FlSpot spot, LineChartBarData barData) {
                    bool flag = spot.x != values.last.index;
                    if (values.length > 6) {
                      flag = flag && spot.x > 1;
                    } else {
                      flag = flag && spot.x != 0;
                    }
                    return flag;
                  },
                ),
                color: corBack,
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                //drawBehindEverything: false,
                drawBelowEverything: false,
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return LegendaEsquerda(
                        value: value,
                        meta: meta,
                      );
                    }),
              ),
              rightTitles: empty,
              topTitles: empty,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: values.length > 8 ? 2 : 1,
                  reservedSize: 30,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return LegendaInferior(
                      meta: meta,
                      item: values.where((GraficoModel element) => element.index == value.truncate()).first,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
