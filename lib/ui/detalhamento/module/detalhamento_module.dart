import 'dart:async';

import 'package:budgetopia/ui/detalhamento/controller/detalhamento_controller.dart';
import 'package:budgetopia/ui/detalhamento/controller/grafico_controller.dart';
import 'package:budgetopia/ui/perfil/case/salvar_perfil_case.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class DetalhamentoModule with DDIModule {
  @override
  void onPostConstruct() {
    Future.wait([
      register(
        factory: ApplicationFactory(builder: PerfilCase.new.builder),
      ),
      application(DetalhamentoController.new),
      application(GraficoController.new),
    ]);
  }
}
