import 'package:budgetopia/ui/home/model/grafico_model.dart';

class GraficoState {
  GraficoState({
    this.saidas = const [],
    this.entradas = const [],
    this.saldo = const [],
    this.valorSaldoObjetivo = 0,
  });

  final List<GraficoModel> saidas;
  final List<GraficoModel> entradas;
  final List<GraficoModel> saldo;
  final double valorSaldoObjetivo;
}
