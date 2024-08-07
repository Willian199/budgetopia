import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/controller/selecao_horizontal_controller.dart';
import 'package:budgetopia/pages/detalhamento/controller/detalhamento_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class DetalhamentoModule with DDIModule {
  @override
  FutureOr<void> onPostConstruct() {
    Future.wait([
      registerComponent(SelecaoHorizontalController.new),
      registerApplication(DetalhamentoController.new),
    ]);
  }
}
