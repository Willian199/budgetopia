import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/ui/detalhamento/controller/grafico_controller.dart';
import 'package:budgetopia/ui/detalhamento/state/grafico_state.dart';
import 'package:budgetopia/ui/detalhamento/view/widget/legenda_esquerda.dart';
import 'package:budgetopia/ui/detalhamento/view/widget/legenda_inferior.dart';
import 'package:budgetopia/ui/home/model/grafico_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class GraficoLinha extends StatefulWidget {
  const GraficoLinha({
    super.key,
  });

  @override
  State<GraficoLinha> createState() => _GraficoLinhaState();
}

class _GraficoLinhaState extends EventListenerState<GraficoLinha, GraficoState> with DDIInject<GraficoController> {
  double minY = 0;

  @override
  void initState() {
    super.initState();
    instance.valorSaldoObjetivo;
  }

  List<GraficoModel> eval(List<GraficoModel> values) {
    if (values.isEmpty) {
      return [];
    }

    minY = values.reduce((current, next) => current.valor < next.valor ? current : next).valor;

    return [
      GraficoModel(index: 0, valor: minY, legenda: ''),
      GraficoModel(index: 1, valor: minY, legenda: ''),
      ...values,
      GraficoModel(index: values.length + 2, valor: minY, legenda: ''),
    ];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building GraficoLinha');
    final ColorScheme colorScheme = AdaptiveTheme.of(context).theme.colorScheme;

    final Color corBack;
    final Color corTooltipSaldoMenor;
    final Color corBordaSaldoMenor;
    final Color corTooltipSaldoOk;
    if (ddi.get<bool>(qualifier: Qualifier.dark_mode)) {
      corBack = colorScheme.primary;
      corTooltipSaldoMenor = colorScheme.errorContainer;
      corBordaSaldoMenor = colorScheme.error;
      corTooltipSaldoOk = colorScheme.tertiaryContainer;
    } else {
      corBack = colorScheme.tertiary;
      corTooltipSaldoMenor = colorScheme.error;
      corBordaSaldoMenor = colorScheme.errorContainer;
      corTooltipSaldoOk = colorScheme.tertiary;
    }

    if (state?.saldo.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    final List<GraficoModel> itensGraficoSaldo = eval(state?.saldo ?? []);
    final List<FlSpot> spotsSaldo = itensGraficoSaldo.map((GraficoModel item) => FlSpot(item.index, item.valor)).toList();

    if (spotsSaldo.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 30),
      child: SafeArea(
        top: false,
        bottom: false,
        child: LineChart(
          LineChartData(
            minY: minY < 0 ? minY : 0,
            minX: 1.2,
            baselineY: minY,
            backgroundColor: Colors.transparent,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                final int tamanho = spotsSaldo.length;

                return spotIndexes.map((int index) {
                  return TouchedSpotIndicatorData(
                    //Cor da linha vertical
                    const FlLine(
                      color: Colors.transparent,
                      strokeWidth: 0,
                    ),
                    //Bolinha ao selecionar o item no gráfico
                    FlDotData(
                      show: (index > 1) && (index < (tamanho - 1)),
                      getDotPainter: (FlSpot spot, double percent, LineChartBarData barData, int index) {
                        return FlDotCirclePainter(
                          radius: 8,
                          color: spot.y > (state?.valorSaldoObjetivo ?? 0) ? corTooltipSaldoOk : corTooltipSaldoMenor,
                          strokeWidth: 3,
                          strokeColor: spot.y > (state?.valorSaldoObjetivo ?? 0) ? corTooltipSaldoOk : corBordaSaldoMenor,
                        );
                      },
                    ),
                  );
                }).toList();
              },
              //Campo do valor ao clicar no gráfico
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (LineBarSpot lineBarSpot) =>
                    lineBarSpot.y > (state?.valorSaldoObjetivo ?? 0) ? corTooltipSaldoOk : corTooltipSaldoMenor,
                tooltipRoundedRadius: 8,
                getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                  return lineBarsSpot.map((LineBarSpot lineBarSpot) {
                    if (lineBarSpot.x > 1 && lineBarSpot.x != itensGraficoSaldo.last.index) {
                      return LineTooltipItem(
                        Moeda.format(
                          valor: lineBarSpot.y,
                          simbolo: Strings.RS,
                        ),
                        const TextStyle(
                          //color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  }).toList();
                },
              ),
            ),
            lineBarsData: <LineChartBarData>[
              LineChartBarData(
                spots: spotsSaldo,
                isCurved: true,
                barWidth: 4,
                preventCurveOverShooting: true,
                shadow: const Shadow(
                  blurRadius: 5,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: corBack,
                ),
                dotData: FlDotData(
                  getDotPainter: (
                    FlSpot spot,
                    double xPercentage,
                    LineChartBarData bar,
                    int index,
                  ) {
                    return FlDotCirclePainter(
                      color: spot.y > (state?.valorSaldoObjetivo ?? 0) ? colorScheme.tertiaryContainer : corTooltipSaldoMenor,
                      radius: 5,
                    );
                  },
                  checkToShowDot: (FlSpot spot, LineChartBarData barData) {
                    return spot.x > 1 && spot.x != itensGraficoSaldo.last.index;
                  },
                ),
                color: corBack,
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                drawBelowEverything: false,
                sideTitles: SideTitles(
                    showTitles: true,
                    maxIncluded: false,
                    minIncluded: false,
                    reservedSize: 60,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return LegendaEsquerda(
                        value: value,
                        meta: meta,
                      );
                    }),
              ),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
              bottomTitles: AxisTitles(
                drawBelowEverything: false,
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: itensGraficoSaldo.length > 12 ? 2 : 1,
                  reservedSize: 30,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return LegendaInferior(
                      meta: meta,
                      item: itensGraficoSaldo.where((GraficoModel element) => element.index == value.truncate()).first,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
