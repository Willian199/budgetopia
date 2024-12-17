import 'package:budgetopia/ui/perfil/case/salvar_perfil_case.dart';
import 'package:budgetopia/ui/perfil/state/data_nascimento_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DataNascimentoController with DDIEventSender<DataNascimentoState> {
  late final PerfilCase _perfilCase = ddi();

  Future<void> selecionarDataNascimento() async {
    final DateTime start = DateTime(1950);
    final DateTime? picked = await showDatePicker(
      context: ddi.get<GlobalKey<NavigatorState>>().currentContext!,
      initialDate: _perfilCase.dataNascimento,
      firstDate: start,
      lastDate: DateTime.now(),
      keyboardType: TextInputType.datetime,
    );

    if (picked != null && picked != _perfilCase.dataNascimento) {
      _perfilCase.dataNascimento = picked;
      fire(DataNascimentoState(picked));
    }
  }

  void alterarDataNascimento(DateTime data) {
    _perfilCase.dataNascimento = data;
    fire(DataNascimentoState(data));
  }
}
