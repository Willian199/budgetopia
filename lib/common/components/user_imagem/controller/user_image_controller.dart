import 'dart:async';

import 'package:budgetopia/common/components/user_imagem/state/user_image_state.dart';
import 'package:budgetopia/common/utils/image_crop.dart';
import 'package:budgetopia/data/service/perfil/perfil_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserImageController extends ValueNotifier<UserImageState> with PostConstruct {
  UserImageController(this._perfilRepository) : super(UserImageState(_perfilRepository.getFirst?.pathImagem));

  final PerfilService _perfilRepository;

  String? get pathImagem => value.path;

  @override
  FutureOr<void> onPostConstruct() {
    _perfilRepository.watchFirst.listen((event) {
      value = UserImageState(event?.pathImagem);
    });
  }

  void selecionarImagem(ImageSource source) async {
    final CroppedFile? imagem = await ImageCrop.pickImage(source);

    if (imagem != null) {
      value = UserImageState(imagem.path);
    }
  }

  void definirPath(String? path) {
    if (path != null) {
      value = UserImageState(path);
    }
  }
}
