import 'dart:async';

import 'package:budgetopia/ui/movimentacao/case/movimentacao_case.dart';
import 'package:budgetopia/ui/movimentacao/controller/categoria_controller.dart';
import 'package:budgetopia/ui/movimentacao/controller/data_movimentacao_controller.dart';
import 'package:budgetopia/ui/movimentacao/controller/status_pagamento_controller.dart';
import 'package:budgetopia/ui/movimentacao/controller/tipo_movimentacao_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class MovimentacaoModule with DDIModule {
  @override
  void onPostConstruct() {
    Future.wait([
      registerApplication(DataMovimentacaoController.new),
      registerApplication(CategoriaController.new),
      registerApplication(TipoMovimentacaoController.new),
      registerApplication(StatusPagamentoController.new),
      registerApplication(MovimentacaoCase.new),
    ]);
  }
}
