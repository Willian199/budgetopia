import 'dart:async';

import 'package:budgetopia/pages/movimentacao/controller/categoria_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/data_movimentacao_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/movimentacao_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/status_pagamento_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/tipo_movimentacao_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class MovimentacaoModule with DDIModule {
  @override
  void onPostConstruct() {
    Future.wait([
      registerApplication(DataMovimentacaoController.new),
      registerApplication(MovimentacaoController.new),
      registerApplication(CategoriaController.new),
      registerApplication(TipoMovimentacaoController.new),
      registerApplication(StatusPagamentoController.new),
    ]);
  }
}
