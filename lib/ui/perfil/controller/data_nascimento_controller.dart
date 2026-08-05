import 'package:budgetopia/common/components/date_picker/cyber_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

/// Controller apenas do estado da data de nascimento (UI). Nao depende de outros controllers.
final class DataNascimentoController extends ValueNotifier<DateTime> {
  DataNascimentoController() : super(DateTime(2006));

  bool _isOpen = false;

  Future<void> selecionarDataNascimento() async {
    final DateTime start = DateTime(1950);

    if (_isOpen) {
      return;
    }

    final BuildContext? context = ddi.get<GlobalKey<NavigatorState>>().currentContext;
    if (context == null) {
      return;
    }

    _isOpen = true;

    try {
      await showDialog(
        context: context,
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
    } finally {
      _isOpen = false;
    }
  }

  void alterarDataNascimento(DateTime data) {
    value = data;
  }
}
