import 'dart:async';

import 'package:budgetopia/common/components/user_imagem/controller/user_image_controller.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository_impl.dart';
import 'package:budgetopia/data/repository/perfil/perfil_repository.dart';
import 'package:budgetopia/data/repository/perfil/perfil_repository_impl.dart';
import 'package:budgetopia/data/service/movimentacao/movimentacao_service.dart';
import 'package:budgetopia/data/service/movimentacao/movimentacao_service_impl.dart';
import 'package:budgetopia/data/service/perfil/perfil_service.dart';
import 'package:budgetopia/data/service/perfil/perfil_service_impl.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class ControlerPageModule with DDIModule {
  @override
  void onPostConstruct() async {
    Future.wait([
      application<MovimentacaoService>(MovimentacaoServiceImpl.new),
      application<MovimentacaoRepository>(MovimentacaoRepositoryImpl.new),
      application<PerfilService>(PerfilServiceImpl.new),
      application<PerfilRepository>(PerfilRepositoryImpl.new),
      register(
        factory: ApplicationFactory(builder: UserImageController.new.builder),
      ),
    ]);
  }
}
