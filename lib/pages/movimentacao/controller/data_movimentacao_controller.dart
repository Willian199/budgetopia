import 'package:budgetopia/pages/movimentacao/state/data_selecionar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DataMovimentacaoController with DDIEventSender<DataSelecionarState> {
  DateTime _dataSelecionada = DateTime.now();
  DateTime get dataSelecionada => _dataSelecionada;

  void selecionarDataMovimentacao(BuildContext context) async {
    final DateTime start = DateTime(2024);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: start,
      lastDate: DateTime(2040),
    );

    if (picked != null && picked != _dataSelecionada) {
      if (picked.isBefore(start)) {
        _dataSelecionada = start;
      } else {
        _dataSelecionada = picked;
      }

      fire(DataSelecionarState(_dataSelecionada));
    }
  }

  void alterarDataMovimentacao(DateTime data) {
    _dataSelecionada = data;
    fire(DataSelecionarState(dataSelecionada));
  }
}
