import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/controller/selecao_horizontal_controller.dart';
import 'package:budgetopia/pages/detalhamento/module/detalhamento_module.dart';
import 'package:budgetopia/pages/detalhamento/state/detalhamento_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DetalhamentoController with DDIEventSender<DetalhamentoState>, PostConstruct {
  DetalhamentoController();

  late final SelecaoHorizontalController _selecaoHorizontalController = ddi.getComponent(module: DetalhamentoModule);

  @override
  FutureOr<void> onPostConstruct() {
    Future.delayed(Durations.short1, () {
      _selecaoHorizontalController.setDados(0, ['Mar', 'Abr', 'Mai', 'Jun']);
    });
  }
}
