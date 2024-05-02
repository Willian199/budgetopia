import 'dart:async';

import 'package:budgetopia/config/banco/repository/perfil/perfil_repository.dart';
import 'package:budgetopia/pages/home/state/imagem_usuario_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class ImagemUsuarioController with DDIEventSender<ImagemUsuarioState>, PostConstruct {
  ImagemUsuarioController() : _perfilRepository = ddi();

  final PerfilRepository _perfilRepository;

  @override
  FutureOr<void> onPostConstruct() {
    fire(ImagemUsuarioState(_perfilRepository.getFirst?.pathImagem));
  }
}
