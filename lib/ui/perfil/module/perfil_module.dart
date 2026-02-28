import 'dart:async';

import 'package:budgetopia/ui/perfil/controller/data_nascimento_controller.dart';
import 'package:budgetopia/ui/perfil/controller/perfil_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class PerfilModule with DDIModule {
  @override
  FutureOr<void> onPostConstruct() {
    Future.wait([
      application(DataNascimentoController.new),
      application(PerfilController.new),
    ]);
  }
}
