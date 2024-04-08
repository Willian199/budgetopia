import 'package:budgetopia/pages/movimentacao/state/status_pagamento_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class StatusPagamentoController with DDIEventSender<StatusPagamentoState> {
  bool _status = false;
  bool get status => _status;

  void alterarStatus(bool status) {
    _status = status;
    fire(StatusPagamentoState(_status));
  }
}
