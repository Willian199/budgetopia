import 'dart:async';

import 'package:budgetopia/common/components/user_imagem/state/user_image_state.dart';
import 'package:budgetopia/common/utils/image_crop.dart';
import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/data/repository/perfil/perfil_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserImageController extends ValueNotifier<UserImageState> with PostConstruct, PreDestroy {
  UserImageController(this._perfilRepository) : super(UserImageState(_perfilRepository.getFirst?.pathImagem));

  final PerfilRepository _perfilRepository;

  String? get pathImagem => value.path;

  StreamSubscription<PerfilEntity?>? _perfilSubscription;

  @override
  FutureOr<void> onPostConstruct() {
    _perfilSubscription = _perfilRepository.watchFirst.listen((event) {
      value = UserImageState(event?.pathImagem);
    });
  }

  Future<void> selecionarImagem(ImageSource source) async {
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

  @override
  FutureOr<void> onPreDestroy() {
    _perfilSubscription?.cancel();
  }
}
