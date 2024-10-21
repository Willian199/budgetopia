import 'dart:async';

import 'package:budgetopia/pages/detalhamento/controller/detalhamento_controller.dart';
import 'package:budgetopia/pages/perfil/controller/salvar_perfil_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class DetalhamentoModule with DDIModule {
  @override
  void onPostConstruct() {
    Future.wait([
      register(
        factory: ScopeFactory.application(builder: PerfilController.new.builder),
      ),
      registerApplication(DetalhamentoController.new),
    ]);
  }
}
