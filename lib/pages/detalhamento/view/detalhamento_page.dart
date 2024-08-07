import 'package:budgetopia/common/components/generics/default_back_button.dart';
import 'package:budgetopia/common/components/generics/degrade.dart';
import 'package:budgetopia/common/components/grafico/grafico_linha.dart';
import 'package:budgetopia/common/components/selecao_horizontal/view/selecao_horizontal.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/pages/detalhamento/controller/detalhamento_controller.dart';
import 'package:budgetopia/pages/detalhamento/module/detalhamento_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DetalhamentoPage extends StatefulWidget {
  const DetalhamentoPage({super.key});

  @override
  State<DetalhamentoPage> createState() => _DetalhamentoPageState();
}

class _DetalhamentoPageState extends State<DetalhamentoPage> with DDIInject<DetalhamentoController> {
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
          child: Column(
            children: [
              const HorizontalSelecaoMes<DetalhamentoModule>(
                  //onPageChanged: (p0) {},
                  ),
              SizedBox(
                height: 500,
                child: GraficoLinha(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
