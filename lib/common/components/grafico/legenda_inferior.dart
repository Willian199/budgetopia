import 'package:budgetopia/pages/home/model/grafico_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LegendaInferior extends StatelessWidget {
  const LegendaInferior({required this.meta, required this.item, super.key});

  final TitleMeta meta;
  final GraficoModel item;

  @override
  Widget build(BuildContext context) {
    if (item.legenda.isEmpty) {
      return Container();
    }

    return SideTitleWidget(
      space: 5,
      axisSide: meta.axisSide,
      child: Text(
        item.legenda,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
