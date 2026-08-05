import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/ui/perfil/controller/user_image_controller.dart';
import 'package:budgetopia/ui/perfil/view/widget/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:image_picker/image_picker.dart';

class UserImagemAvatar extends StatelessWidget {
  const UserImagemAvatar({super.key});

  Future<void> _selecionarImagem(BuildContext context, ImageSource source) async {
    Navigator.of(context).pop();
    await ddi.get<UserImageController>().selecionarImagem(source);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Wrap(
                children: [
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text(Strings.GALERIA),
                    onTap: () => _selecionarImagem(bc, ImageSource.gallery),
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text(Strings.CAMERA),
                    onTap: () => _selecionarImagem(bc, ImageSource.camera),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: const UserImage(),
    );
  }
}
