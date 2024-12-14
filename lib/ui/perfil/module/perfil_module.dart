import 'dart:async';

import 'package:budgetopia/ui/perfil/controller/data_nascimento_controller.dart';
import 'package:budgetopia/ui/perfil/controller/salvar_perfil_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class PerfilModule with DDIModule {
  @override
  FutureOr<void> onPostConstruct() {
    Future.wait([
      registerApplication(DataNascimentoController.new),
      register(
        factory: ScopeFactory.application(builder: PerfilController.new.builder),
      ),
    ]);
  }
}