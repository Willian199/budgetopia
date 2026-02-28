import 'package:budgetopia/common/components/date_picker/cyber_date_pickert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

/// Controller apenas do estado da data de nascimento (UI). Não depende de outros controllers.
final class DataNascimentoController extends ValueNotifier<DateTime> {
  DataNascimentoController() : super(DateTime(2006));

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
        initialDate: value,
        firstDate: start,
        lastDate: DateTime.now(),
        onDateSelected: (picked) {
          if (picked != value) {
            value = picked;
          }
        },
      ),
    );

    _isOpen = false;
  }

  void alterarDataNascimento(DateTime data) {
    value = data;
  }
}
