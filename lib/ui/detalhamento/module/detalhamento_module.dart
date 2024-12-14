import 'dart:async';

import 'package:budgetopia/ui/detalhamento/controller/detalhamento_controller.dart';
import 'package:budgetopia/ui/detalhamento/controller/grafico_controller.dart';
import 'package:budgetopia/ui/perfil/controller/salvar_perfil_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class DetalhamentoModule with DDIModule {
  @override
  void onPostConstruct() {
    Future.wait([
      register(
        factory: ScopeFactory.application(builder: PerfilController.new.builder),
      ),
      registerApplication(DetalhamentoController.new),
      registerApplication(GraficoController.new),
    ]);
  }
}
