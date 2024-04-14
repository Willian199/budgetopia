import 'package:budgetopia/common/components/generics/default_back_button.dart';
import 'package:budgetopia/common/components/generics/degrade.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class DetalhamentoPage extends StatefulWidget {
  const DetalhamentoPage({super.key});

  @override
  State<DetalhamentoPage> createState() => _DetalhamentoPageState();
}

class _DetalhamentoPageState extends State<DetalhamentoPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = context.theme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.DETALHAMENTO),
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
          child: Container(),
        ),
      ),
    );
  }
}
