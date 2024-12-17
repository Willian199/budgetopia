import 'package:budgetopia/ui/movimentacao/case/movimentacao_case.dart';
import 'package:budgetopia/ui/movimentacao/state/status_pagamento_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class StatusPagamentoController with DDIEventSender<StatusPagamentoState> {
  late final MovimentacaoCase _movimentacaoCase = ddi();
  void alterarStatus(bool value) {
    _movimentacaoCase.status = value;
    fire(StatusPagamentoState(value));
  }
}
