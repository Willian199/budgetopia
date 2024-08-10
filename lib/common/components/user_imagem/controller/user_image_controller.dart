import 'dart:async';

import 'package:budgetopia/common/components/user_imagem/state/user_image_state.dart';
import 'package:budgetopia/common/image_crop/image_crop.dart';
import 'package:budgetopia/config/banco/repository/perfil/perfil_repository.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserImageController with DDIEventSender<UserImageState>, PostConstruct {
  UserImageController() : _perfilRepository = ddi();

  final PerfilRepository _perfilRepository;

  String? get pathImagem => super.state?.path;

  @override
  FutureOr<void> onPostConstruct() {
    _perfilRepository.watchFirst.listen((event) {
      fire(UserImageState(event?.pathImagem));
    });
  }

  void selecionarImagem(ImageSource source) async {
    final CroppedFile? imagem = await ImageCrop.pickImage(source);

    if (imagem != null) {
      fire(UserImageState(imagem.path));
    }
  }

  void definirPath(String? path) {
    if (path != null) {
      fire(UserImageState(path));
    }
  }
}