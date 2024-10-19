import 'package:budgetopia/pages/perfil/state/data_nascimento_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DataNascimentoController with DDIEventSender<DataNascimentoState> {
  DateTime get dataNascimento => super.state?.data ?? DateTime(2006);

  Future<void> selecionarDataNascimento() async {
    final DateTime start = DateTime(1950);
    final DateTime? picked = await showDatePicker(
      context: ddi.get<GlobalKey<NavigatorState>>().currentContext!,
      initialDate: dataNascimento,
      firstDate: start,
      lastDate: DateTime.now(),
      keyboardType: TextInputType.datetime,
    );

    if (picked != null && picked != dataNascimento) {
      fire(DataNascimentoState(picked));
    }
  }

  void alterarDataNascimento(DateTime data) {
    fire(DataNascimentoState(data));
  }
}
