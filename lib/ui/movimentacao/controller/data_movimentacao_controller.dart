import 'package:budgetopia/ui/movimentacao/case/movimentacao_case.dart';
import 'package:budgetopia/ui/movimentacao/state/data_selecionar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DataMovimentacaoController with DDIEventSender<DataSelecionarState> {
  late final MovimentacaoCase _movimentacaoCase = ddi();

  Future<void> selecionarDataMovimentacao() async {
    final DateTime start = DateTime(2024);
    final DateTime? picked = await showDatePicker(
      context: ddi.get<GlobalKey<NavigatorState>>().currentContext!,
      initialDate: _movimentacaoCase.dataSelecionada,
      firstDate: start,
      lastDate: DateTime(2040),
      keyboardType: TextInputType.datetime,
    );

    if (picked != null && picked != _movimentacaoCase.dataSelecionada) {
      final data = picked.isBefore(start) ? start : picked;
      _movimentacaoCase.dataSelecionada = data;
      fire(DataSelecionarState(data));
    }
  }

  void alterarDataMovimentacao(DateTime data) {
    _movimentacaoCase.dataSelecionada = data;
    fire(DataSelecionarState(data));
  }
}
