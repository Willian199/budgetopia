import 'dart:io';

import 'package:budgetopia/common/components/generics/default_back_button.dart';
import 'package:budgetopia/common/components/generics/degrade.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  CroppedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _monthlyGoalController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _occupationController.dispose();
    _monthlyGoalController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  Future<void> _cropImage(File imageFile) async {
    final CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
      ],
    );

    if (cropped != null) {
      setState(() {
        _imageFile = cropped;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = context.theme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.PERFIL),
        leading: const DefaultBackButton(),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: Degrade.efeitoDegrade(
          cores: <Color>[
            tema.colorScheme.primaryContainer,
            tema.colorScheme.onSecondary,
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Photo Library'),
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_camera),
                              title: const Text('Camera'),
                              onTap: () {
                                _pickImage(ImageSource.camera);
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
                  backgroundImage:
                      _imageFile != null ? FileImage(File(_imageFile!.path)) as ImageProvider : const AssetImage('assets/default_avatar.jpg'),
                  // backgroundImage: const AssetImage('assets/default_avatar.jpg'),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _dobController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _occupationController,
                decoration: const InputDecoration(
                  labelText: 'Occupation',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _monthlyGoalController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Spending Goal',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
