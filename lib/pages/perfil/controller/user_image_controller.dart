import 'package:budgetopia/common/image_crop/image_crop.dart';
import 'package:budgetopia/pages/perfil/state/user_image_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserImageController with DDIEventSender<UserImageState> {
  String? get pathImagem => super.state?.image;
  void selecionarImagem(ImageSource source) async {
    final CroppedFile? imagem = await ImageCrop.pickImage(source);

    if (imagem != null) {
      fire(UserImageState(image: imagem.path));
    }
  }

  void definirPath(String? path) {
    if (path != null) {
      fire(UserImageState(image: path));
    }
  }
}
