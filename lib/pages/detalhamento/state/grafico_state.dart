import 'package:budgetopia/pages/home/model/grafico_model.dart';

class GraficoState {
  GraficoState({
    this.saidas = const [],
    this.entradas = const [],
    this.saldo = const [],
  });

  final List<GraficoModel> saidas;
  final List<GraficoModel> entradas;
  final List<GraficoModel> saldo;
}
