import 'dart:io';

import 'package:budgetopia/ui/perfil/controller/user_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class UserImage extends StatefulWidget {
  const UserImage({super.key});

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends ListenableState<UserImage, UserImageController> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[200],
      backgroundImage: listenable.pathImagem != null
          ? FileImage(File(listenable.pathImagem!)) as ImageProvider
          : const AssetImage('assets/icons/user.png'),
    );
  }
}
