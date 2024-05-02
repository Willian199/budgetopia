import 'package:budgetopia/common/components/user_imagem/controller/user_image_controller.dart';
import 'package:budgetopia/common/components/user_imagem/view/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:image_picker/image_picker.dart';

class UserImagemAvatar extends StatefulWidget {
  const UserImagemAvatar({super.key});

  @override
  State<UserImagemAvatar> createState() => _UserImagemAvatarState();
}

class _UserImagemAvatarState extends State<UserImagemAvatar> with DDIInject<UserImageController> {
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
                    title: const Text('Galeria'),
                    onTap: () {
                      instance.selecionarImagem(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      instance.selecionarImagem(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
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
