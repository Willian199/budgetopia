import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/common/constantes/strings.dart';
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
  double minY = 0;
  int _selectedSpotIndex = 0;

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
    final ThemeData tema = AdaptiveTheme.of(context).theme;
    final bool isDarkMode = ddi.get<bool>(qualifier: Qualifier.dark_mode);

    // Definição de cores
    final Color primaryColor = tema.colorScheme.primary;
    final Color tertiaryColor = tema.colorScheme.tertiary;

    // Cores adaptativas para o gráfico
    final Color corLineChart = isDarkMode ? tertiaryColor : primaryColor;
    final Color corErro = tema.colorScheme.error;
    final Color corTooltipSaldoOk = tertiaryColor;
    final Color corTooltipSaldoMenor = corErro;
    final Color corBordaSaldoMenor = corErro.withValues(alpha: 0.7);

    if (listenable.value.saldo.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<GraficoModel> itensGraficoSaldo = eval(listenable.value.saldo);
    final List<FlSpot> spotsSaldo = itensGraficoSaldo
        .map((GraficoModel item) => FlSpot(item.index.toDouble(), item.valor))
        .toList();

    if (spotsSaldo.isEmpty) {
      return const SizedBox.shrink();
    }

    // Determinar o índice do valor mais recente/atual (excluindo os valores de padding)
    _selectedSpotIndex = spotsSaldo.length > 4 ? spotsSaldo.length - 2 : 2;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 20),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return LineChart(
                LineChartData(
                  minY: minY < 0 ? minY : 0,
                  minX: itensGraficoSaldo.first.index.toDouble(),
                  maxX: itensGraficoSaldo.last.index.toDouble(),
                  baselineY: 0,
                  backgroundColor: Colors.transparent,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                      final int tamanho = spotsSaldo.length;

                      return spotIndexes.map((int index) {
                        final bool isValidForTouch = (index > 1) && (index < (tamanho - 1));

                        return TouchedSpotIndicatorData(
                          // Linha vertical sutil
                          FlLine(
                            color: isValidForTouch ? corLineChart.withValues(alpha: 0.2) : Colors.transparent,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          ),
                          // Bolinha ao selecionar o item no gráfico
                          FlDotData(
                            show: isValidForTouch,
                            getDotPainter:
                                (
                                  FlSpot spot,
                                  double percent,
                                  LineChartBarData barData,
                                  int index,
                                ) {
                                  final bool isSaldoOk = spot.y > listenable.value.valorSaldoObjetivo;

                                  return FlDotCirclePainter(
                                    radius: 8,
                                    color: isSaldoOk ? corTooltipSaldoOk : corTooltipSaldoMenor,
                                    strokeWidth: 3,
                                    strokeColor: isSaldoOk
                                        ? corTooltipSaldoOk.withValues(
                                            alpha: 0.5,
                                          )
                                        : corBordaSaldoMenor,
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
                          if (lineBarSpot.x > 1 && lineBarSpot.x < itensGraficoSaldo.last.index) {
                            final GraficoModel item = itensGraficoSaldo.firstWhere(
                              (element) => element.index == lineBarSpot.x.toInt(),
                              orElse: () => itensGraficoSaldo[2], // Fallback para evitar exceções
                            );

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
                        setState(() {
                          _selectedSpotIndex = touchResponse.lineBarSpots!.first.spotIndex;
                        });
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
                        interval: itensGraficoSaldo.length > 12 ? 2 : 1,
                        reservedSize: 30,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return LegendaInferior(
                            selectedSpotIndex: _selectedSpotIndex,
                            value: value,
                            meta: meta,
                            item: itensGraficoSaldo
                                .where(
                                  (element) => element.index == value.toInt(),
                                )
                                .firstOrNull,
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: <LineChartBarData>[
                    LineChartBarData(
                      spots: spotsSaldo.asMap().entries.map((entry) {
                        final FlSpot spot = entry.value;
                        // Aplicar animação ao valor Y
                        return FlSpot(
                          spot.x,
                          spot.y * _animationController.value,
                        );
                      }).toList(),
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
                            corLineChart.withValues(
                              alpha: 0.3 * _animationController.value,
                            ),
                            corLineChart.withValues(
                              alpha: 0.1 * _animationController.value,
                            ),
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
                              final bool isCurrent = index == _selectedSpotIndex;
                              final bool isSaldoOk = spot.y > listenable.value.valorSaldoObjetivo;

                              return FlDotCirclePainter(
                                radius: isCurrent ? 6 : 4,
                                strokeWidth: isCurrent ? 2 : 1,
                                color: isSaldoOk
                                    ? corTooltipSaldoOk.withValues(
                                        alpha: isCurrent ? 1.0 : 0.7,
                                      )
                                    : corTooltipSaldoMenor.withValues(
                                        alpha: isCurrent ? 1.0 : 0.7,
                                      ),
                                strokeColor: Colors.white.withValues(
                                  alpha: 0.5,
                                ),
                              );
                            },
                        checkToShowDot: (FlSpot spot, LineChartBarData barData) {
                          return spot.x > 1 && spot.x < itensGraficoSaldo.last.index;
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

        // Texto de Análise na parte superior
        Positioned(
          left: 40,
          top: 10,
          child: Row(
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
              const SizedBox(width: 8),
              Text(
                "ANÁLISE TEMPORAL",
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
