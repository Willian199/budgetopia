import 'package:budgetopia/common/components/date_picker/cyber_date_pickert.dart';
import 'package:budgetopia/ui/perfil/case/salvar_perfil_case.dart';
import 'package:budgetopia/ui/perfil/state/data_nascimento_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class DataNascimentoController extends ValueNotifier<DataNascimentoState> {
  DataNascimentoController() : super(DataNascimentoState(DateTime(2006)));
  late final PerfilCase _perfilCase = ddi();

  bool _isOpen = false;

  Future<void> selecionarDataNascimento() async {
    final DateTime start = DateTime(1950);

    if (_isOpen) {
      return;
    }

    _isOpen = true;

    await showDialog(
      context: ddi.get<GlobalKey<NavigatorState>>().currentContext!,
      builder: (context) => CyberDatePicker(
        initialDate: _perfilCase.dataNascimento,
        firstDate: start,
        lastDate: DateTime.now(),
        onDateSelected: (picked) {
          if (picked != _perfilCase.dataNascimento) {
            _perfilCase.dataNascimento = picked;
            value = DataNascimentoState(picked);
          }
        },
      ),
    );

    _isOpen = false;
  }

  void alterarDataNascimento(DateTime data) {
    _perfilCase.dataNascimento = data;
    value = DataNascimentoState(data);
  }
}
