import 'dart:async';

import 'package:budgetopia/common/components/user_imagem/controller/user_image_controller.dart';
import 'package:budgetopia/config/banco/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/config/banco/repository/movimentacao/movimentacao_repository_impl.dart';
import 'package:budgetopia/config/banco/repository/perfil/perfil_repository.dart';
import 'package:budgetopia/config/banco/repository/perfil/perfil_repository_impl.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class ControlerPageModule with DDIModule {
  @override
  FutureOr<void> onPostConstruct() {
    registerApplication<MovimentacaoRepository>(MovimentacaoRepositoryImpl.new);
    registerApplication<PerfilRepository>(PerfilRepositoryImpl.new);
    registerApplication(UserImageController.new);
  }
}
