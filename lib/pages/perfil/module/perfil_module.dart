import 'dart:async';

import 'package:budgetopia/pages/perfil/controller/data_nascimento_controller.dart';
import 'package:budgetopia/pages/perfil/controller/salvar_perfil_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class PerfilModule with DDIModule {
  @override
  FutureOr<void> onPostConstruct() {
    Future.wait([
      registerApplication(DataNascimentoController.new),
      registerApplication(SalvarPerfilController.new),
    ]);
  }
}
