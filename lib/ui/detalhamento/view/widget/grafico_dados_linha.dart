import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/ui/detalhamento/controller/grafico_controller.dart';
import 'package:budgetopia/ui/detalhamento/view/widget/legenda_inferior.dart';
import 'package:budgetopia/ui/home/model/grafico_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class GraficoDadosLinha extends StatefulWidget {
  const GraficoDadosLinha({super.key});

  @override
  State<GraficoDadosLinha> createState() => _GraficoDadosLinhaState();
}

class _GraficoDadosLinhaState extends ListenableState<GraficoDadosLinha, GraficoController>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = context.theme;
    final bool isDarkMode = ddi.get<bool>(qualifier: Qualifier.dark_mode);

    final Color primaryColor = tema.colorScheme.primary;
    final Color tertiaryColor = tema.colorScheme.tertiary;
    final Color corLineChart = isDarkMode ? tertiaryColor : primaryColor;
    final Color corTooltipSaldoMenor = tema.colorScheme.error;
    final Color corBordaSaldoMenor = corTooltipSaldoMenor.withValues(alpha: 0.7);

    final grafico = listenable.value;

    if (grafico.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 20),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return LineChart(
                LineChartData(
                  minY: grafico.minY,
                  maxY: grafico.maxY,
                  minX: grafico.minX,
                  maxX: grafico.maxX,
                  baselineY: 0,
                  backgroundColor: Colors.transparent,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                      final int tamanho = grafico.spots.length;

                      return spotIndexes.map((int index) {
                        final bool isValidIndex = index >= 0 && index < tamanho;
                        final bool isValidForTouch = isValidIndex && listenable.isSpotReal(grafico.spots[index]);

                        return TouchedSpotIndicatorData(
                          FlLine(
                            color: isValidForTouch ? corLineChart.withValues(alpha: 0.2) : Colors.transparent,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          ),
                          FlDotData(
                            show: isValidForTouch,
                            getDotPainter:
                                (
                                  FlSpot spot,
                                  double percent,
                                  LineChartBarData barData,
                                  int index,
                                ) {
                                  final bool isSaldoOk = listenable.isSaldoOk(spot.y);

                                  return FlDotCirclePainter(
                                    radius: 8,
                                    color: isSaldoOk ? tertiaryColor : corTooltipSaldoMenor,
                                    strokeWidth: 3,
                                    strokeColor: isSaldoOk ? tertiaryColor.withValues(alpha: 0.5) : corBordaSaldoMenor,
                                  );
                                },
                          ),
                        );
                      }).toList();
                    },
                    touchTooltipData: LineTouchTooltipData(
                      tooltipMargin: 8,
                      tooltipBorder: BorderSide(
                        color: corLineChart.withValues(alpha: 0.5),
                      ),
                      tooltipBorderRadius: const BorderRadius.all(Radius.circular(8)),
                      tooltipPadding: const EdgeInsets.all(8),
                      getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                        return lineBarsSpot.map((LineBarSpot lineBarSpot) {
                          if (listenable.isSpotReal(lineBarSpot)) {
                            final GraficoModel item = listenable.itemPorX(lineBarSpot.x);

                            return LineTooltipItem(
                              '${item.legenda}\n${Moeda.format(valor: lineBarSpot.y, simbolo: Strings.RS)}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            );
                          }
                          return null;
                        }).toList();
                      },
                    ),
                    touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                      if (touchResponse?.lineBarSpots != null &&
                          touchResponse!.lineBarSpots!.isNotEmpty &&
                          (event is FlTapUpEvent || event is FlPanEndEvent)) {
                        final FlSpot touchedSpot = touchResponse.lineBarSpots!.first;
                        if (!listenable.isSpotReal(touchedSpot)) {
                          return;
                        }

                        listenable.selecionarSpotX(touchedSpot.x.toInt());
                      }
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 10,
                            child: Text(
                              meta.formattedValue,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: corLineChart.withValues(alpha: 0.7),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: grafico.intervaloLegendaInferior.toDouble(),
                        reservedSize: 30,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return LegendaInferior(
                            selectedSpotIndex: grafico.selectedSpotX,
                            value: value,
                            meta: meta,
                            item: grafico.itens.where((element) => element.index == value.toInt()).firstOrNull,
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: <LineChartBarData>[
                    LineChartBarData(
                      spots: listenable.spotsAnimados(_animationController.value),
                      isCurved: true,
                      curveSmoothness: 0.3,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      preventCurveOverShooting: true,
                      shadow: Shadow(
                        blurRadius: 8,
                        color: corLineChart.withValues(alpha: 0.5),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            corLineChart.withValues(alpha: 0.3 * _animationController.value),
                            corLineChart.withValues(alpha: 0.1 * _animationController.value),
                            corLineChart.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                      dotData: FlDotData(
                        getDotPainter:
                            (
                              FlSpot spot,
                              double percent,
                              LineChartBarData bar,
                              int index,
                            ) {
                              final bool isCurrent = spot.x.toInt() == grafico.selectedSpotX;
                              final bool isSaldoOk = listenable.isSaldoOk(spot.y);

                              return FlDotCirclePainter(
                                radius: isCurrent ? 6 : 4,
                                strokeWidth: isCurrent ? 2 : 1,
                                color: isSaldoOk
                                    ? tertiaryColor.withValues(alpha: isCurrent ? 1.0 : 0.7)
                                    : corTooltipSaldoMenor.withValues(alpha: isCurrent ? 1.0 : 0.7),
                                strokeColor: Colors.white.withValues(alpha: 0.5),
                              );
                            },
                        checkToShowDot: (FlSpot spot, LineChartBarData barData) {
                          return listenable.isSpotReal(spot);
                        },
                      ),
                      color: corLineChart,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          left: 40,
          top: 10,
          child: Row(
            spacing: 8,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: tertiaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: tertiaryColor.withValues(alpha: 0.6),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              Text(
                'ANÁLISE TEMPORAL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: tertiaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
