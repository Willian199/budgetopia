import 'dart:async';

import 'package:budgetopia/data/repository/detalhamento/detalhamento_repository.dart';
import 'package:budgetopia/ui/detalhamento/state/grafico_state.dart';
import 'package:budgetopia/ui/home/model/grafico_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class GraficoController extends ValueNotifier<GraficoState> with PostConstruct, PreDestroy {
  GraficoController() : super(_emptyState());

  late final DetalhamentoRepository _detalhamentoRepository = ddi();
  late StreamSubscription<DetalhamentoDados> _refer;

  @override
  FutureOr<void> onPostConstruct() {
    _refer = _detalhamentoRepository.buscarDados().listen((DetalhamentoDados dados) {
      value = _criarState(dados.grafico.saldo, dados.valorSaldoObjetivo, value.selectedSpotX);
    });
  }

  void selecionarSpotX(int spotX) {
    value = GraficoState(
      itens: value.itens,
      spots: value.spots,
      minY: value.minY,
      maxY: value.maxY,
      minX: value.minX,
      maxX: value.maxX,
      selectedSpotX: _selectedSpotXOrDefault(value.itens, spotX),
      valorSaldoObjetivo: value.valorSaldoObjetivo,
      isEmpty: value.isEmpty,
      intervaloLegendaInferior: value.intervaloLegendaInferior,
    );
  }

  bool isSpotReal(FlSpot spot) => spot.x > 1 && spot.x <= value.maxX;

  bool isSaldoOk(double valor) => valor >= value.valorSaldoObjetivo;

  GraficoModel itemPorX(double x) => value.itens.firstWhere(
      (element) => element.index == x.toInt(),
      orElse: () => value.itens[1],
    );

  List<FlSpot> spotsAnimados(double valorAnimacao) => value.spots.map((spot) => FlSpot(spot.x, spot.y * valorAnimacao)).toList();

  static GraficoState _criarState(List<GraficoModel> saldo, double valorSaldoObjetivo, int selectedSpotX) {
    if (saldo.isEmpty) {
      return _emptyState();
    }

    final double menorValor = saldo.reduce((current, next) => current.valor < next.valor ? current : next).valor;
    final double maiorValor = saldo.reduce((current, next) => current.valor > next.valor ? current : next).valor;

    final List<GraficoModel> itens = [
      GraficoModel(index: 0, valor: saldo.length > 1 ? menorValor : 0, legenda: ''),
      ...saldo,
    ];
    final double minY = _calcularMinY(menorValor);

    return GraficoState(
      itens: itens,
      spots: itens.map((item) => FlSpot(item.index.toDouble(), item.valor)).toList(),
      minY: minY,
      maxY: _calcularMaxY(
        menorValor: menorValor,
        maiorValor: maiorValor,
        minY: minY,
      ),
      minX: itens.first.index.toDouble(),
      maxX: itens.last.index.toDouble(),
      selectedSpotX: _selectedSpotXOrDefault(itens, selectedSpotX),
      valorSaldoObjetivo: valorSaldoObjetivo,
      isEmpty: false,
      intervaloLegendaInferior: itens.length > 12 ? 2 : 1,
    );
  }

  static GraficoState _emptyState() {
    return GraficoState(
      itens: const [],
      spots: const [],
      minY: 0,
      maxY: 0,
      minX: 0,
      maxX: 0,
      selectedSpotX: 0,
      valorSaldoObjetivo: 0,
      isEmpty: true,
      intervaloLegendaInferior: 1,
    );
  }

  static double _calcularMinY(double menorValor) => menorValor < 0 ? menorValor * 1.1 : 0;

  static double _calcularMaxY({
    required double menorValor,
    required double maiorValor,
    required double minY,
  }) {
    final double maxY = switch (maiorValor) {
      > 0 => maiorValor * 1.1,
      < 0 => maiorValor + maiorValor.abs() * 0.1,
      _ => menorValor < 0 ? 0 : 1,
    };

    return maxY > minY ? maxY : minY + 1;
  }

  static int _selectedSpotXOrDefault(List<GraficoModel> itens, int selectedSpotX) {
    final bool hasSelectedSpot = itens.any((item) => item.index.toInt() == selectedSpotX);
    if (selectedSpotX > 1 && hasSelectedSpot) {
      return selectedSpotX;
    }

    return itens.isEmpty ? 0 : itens.last.index.toInt();
  }

  @override
  FutureOr<void> onPreDestroy() {
    _refer.cancel();
  }
}
