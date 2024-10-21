import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/pages/home/model/grafico_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LegendaInferior extends StatelessWidget {
  const LegendaInferior({required this.meta, required this.item, super.key});

  final TitleMeta meta;
  final GraficoModel item;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = AdaptiveTheme.of(context).theme.colorScheme;

    if (item.legenda.isEmpty) {
      return const SizedBox();
    }

    return SideTitleWidget(
      space: 5,
      axisSide: meta.axisSide,
      child: Text(
        item.legenda,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.primaryContainer,
        ),
      ),
    );
  }
}
