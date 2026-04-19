import 'package:budgetopia/ui/home/model/grafico_model.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoState {
  GraficoState({
    required this.itens,
    required this.spots,
    required this.minY,
    required this.maxY,
    required this.minX,
    required this.maxX,
    required this.selectedSpotX,
    required this.valorSaldoObjetivo,
    required this.isEmpty,
    required this.intervaloLegendaInferior,
  });

  final List<GraficoModel> itens;
  final List<FlSpot> spots;
  final double minY;
  final double maxY;
  final double minX;
  final double maxX;
  final int selectedSpotX;
  final double valorSaldoObjetivo;
  final bool isEmpty;
  final int intervaloLegendaInferior;
}
