import 'dart:io';

import 'package:budgetopia/common/components/user_imagem/controller/user_image_controller.dart';
import 'package:budgetopia/common/components/user_imagem/state/user_image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class UserImage extends StatefulWidget {
  const UserImage({super.key});

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends EventListenerState<UserImage, UserImageState> with DDIInject<UserImageController> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[200],
      backgroundImage: state?.path != null ? FileImage(File(state!.path!)) as ImageProvider : const AssetImage('assets/icons/user.png'),
    );
  }
}
