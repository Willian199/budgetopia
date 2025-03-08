import 'package:budgetopia/ui/movimentacao/case/movimentacao_case.dart';
import 'package:budgetopia/ui/movimentacao/state/status_pagamento_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class StatusPagamentoController extends ValueNotifier<StatusPagamentoState> {
  StatusPagamentoController() : super(StatusPagamentoState(false));

  late final MovimentacaoCase _movimentacaoCase = ddi();
  void alterarStatus(bool status) {
    _movimentacaoCase.status = status;
    value = StatusPagamentoState(status);
  }
}
