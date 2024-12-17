import 'dart:async';

import 'package:budgetopia/data/repository/perfil/perfil_repository.dart';
import 'package:budgetopia/ui/home/state/imagem_usuario_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class ImagemUsuarioController with DDIEventSender<ImagemUsuarioState>, PostConstruct {
  late final PerfilRepository _perfilRepository = ddi();

  @override
  FutureOr<void> onPostConstruct() {
    fire(ImagemUsuarioState(_perfilRepository.getFirst?.pathImagem));
  }
}
