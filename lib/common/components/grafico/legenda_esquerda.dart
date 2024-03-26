import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LegendaEsquerda extends StatelessWidget {
  const LegendaEsquerda({required this.value, required this.meta, super.key});

  final double value;
  final TitleMeta meta;

  @override
  Widget build(BuildContext context) {
    if (value == 0.0) {
      return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
