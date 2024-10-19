import 'package:budgetopia/pages/movimentacao/state/data_selecionar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DataMovimentacaoController with DDIEventSender<DataSelecionarState> {
  DateTime get dataSelecionada => super.state?.data ?? DateTime.now();

  Future<void> selecionarDataMovimentacao() async {
    final DateTime start = DateTime(2024);
    final DateTime? picked = await showDatePicker(
      context: ddi.get<GlobalKey<NavigatorState>>().currentContext!,
      initialDate: dataSelecionada,
      firstDate: start,
      lastDate: DateTime(2040),
      keyboardType: TextInputType.datetime,
    );

    if (picked != null && picked != dataSelecionada) {
      fire(DataSelecionarState(picked.isBefore(start) ? start : picked));
    }
  }

  void alterarDataMovimentacao(DateTime data) {
    fire(DataSelecionarState(data));
  }
}
