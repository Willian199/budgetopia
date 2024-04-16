import 'dart:io';

import 'package:budgetopia/pages/perfil/controller/user_image_controller.dart';
import 'package:budgetopia/pages/perfil/state/user_image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:image_picker/image_picker.dart';

class UserImagemAvatar extends StatefulWidget {
  const UserImagemAvatar({super.key});

  @override
  State<UserImagemAvatar> createState() => _UserImagemAvatarState();
}

class _UserImagemAvatarState extends EventListenerState<UserImagemAvatar, UserImageState> with DDIInject<UserImageController> {
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
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        backgroundImage: state?.image != null ? FileImage(File(state!.image)) as ImageProvider : const AssetImage('assets/icons/user.png'),
      ),
    );
  }
}
