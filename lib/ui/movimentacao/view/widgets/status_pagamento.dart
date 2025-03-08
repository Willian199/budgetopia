import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/constantes/double.dart';
import 'package:budgetopia/ui/movimentacao/controller/status_pagamento_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class StatusPagamento extends StatefulWidget {
  const StatusPagamento({super.key});

  @override
  State<StatusPagamento> createState() => _StatusPagamentoState();
}

class _StatusPagamentoState extends ListenableState<StatusPagamento, StatusPagamentoController> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = AdaptiveTheme.of(context).theme.colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: Double.DEZ),
          child: Text("Transação realizada: "),
        ),
        Switch.adaptive(
          value: listenable.value.status,
          inactiveThumbColor: colorScheme.error,
          inactiveTrackColor: colorScheme.onError,
          onChanged: listenable.alterarStatus,
        ),
      ],
    );
  }
}
