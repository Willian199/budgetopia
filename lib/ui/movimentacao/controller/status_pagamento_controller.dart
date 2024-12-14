import 'package:budgetopia/ui/movimentacao/state/status_pagamento_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class StatusPagamentoController with DDIEventSender<StatusPagamentoState> {
  bool get status => super.state?.status ?? false;

  void alterarStatus(bool value) {
    fire(StatusPagamentoState(value));
  }
}
