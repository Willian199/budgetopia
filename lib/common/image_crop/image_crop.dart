import 'dart:io';

import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/permissoes/permissao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

final class ImageCrop {
  static final ImagePicker _picker = ImagePicker();

  static Future<CroppedFile?> _cropImage(File imageFile) async {
    late final key = ddi.get<GlobalKey<NavigatorState>>();
    late final ColorScheme colorScheme = key.currentContext!.colorScheme;

    late final bool darkMode = ddi.get(qualifier: Qualifier.dark_mode);

    final CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: Strings.SELECIONAR_IMAGEM,
          toolbarColor: colorScheme.primaryContainer,
          toolbarWidgetColor: darkMode ? Colors.white : colorScheme.primary,
          cropFrameColor: colorScheme.primary,
          showCropGrid: false,
          backgroundColor: colorScheme.primaryContainer,
          dimmedLayerColor: Colors.black26,
          activeControlsWidgetColor: colorScheme.primary,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          cropStyle: CropStyle.circle,
        ),
        IOSUiSettings(
          cropStyle: CropStyle.circle,
          minimumAspectRatio: 1.0,
        )
      ],
    );

    return cropped;
  }

  static Future<CroppedFile?> pickImage(ImageSource source) async {
    final bool isGranted = switch (source) {
      ImageSource.gallery => await Permissao.requestGaleria(),
      ImageSource.camera => await Permissao.requestCamera(),
    };

    if (isGranted) {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        return _cropImage(File(pickedFile.path));
      }
    }

    return null;
  }
}
