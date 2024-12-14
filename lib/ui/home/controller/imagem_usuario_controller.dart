import 'dart:async';

import 'package:budgetopia/data/service/perfil/perfil_service.dart';
import 'package:budgetopia/ui/home/state/imagem_usuario_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class ImagemUsuarioController with DDIEventSender<ImagemUsuarioState>, PostConstruct {
  ImagemUsuarioController() : _perfilService = ddi();

  final PerfilService _perfilService;

  @override
  FutureOr<void> onPostConstruct() {
    fire(ImagemUsuarioState(_perfilService.getFirst?.pathImagem));
  }
}
