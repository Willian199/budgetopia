import 'package:budgetopia/pages/detalhamento/module/detalhamento_module.dart';
import 'package:budgetopia/pages/detalhamento/view/detalhamento_page.dart';
import 'package:budgetopia/pages/drawer/module/controler_page_module.dart';
import 'package:budgetopia/pages/home/module/home_module.dart';
import 'package:budgetopia/pages/home/view/home_page.dart';
import 'package:budgetopia/pages/perfil/module/perfil_module.dart';
import 'package:budgetopia/pages/perfil/view/perfil_page.dart';
import 'package:budgetopia/pages/sobre/sobre_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class ControllerPage extends StatefulWidget {
  const ControllerPage({super.key});

  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> with DDIInject<PageController> {
  @override
  Widget build(BuildContext context) {
    debugPrint("Rebuilding ControllerPage");
    return FlutterDDIWidget(
      module: ControlerPageModule.new,
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: instance,
        children: <Widget>[
          FlutterDDIFutureWidget(
            module: HomeModule.new,
            child: (_) => const HomePage(),
          ),
          FlutterDDIFutureWidget(
            module: DetalhamentoModule.new,
            child: (_) => const DetalhamentoPage(),
          ),
          const FlutterDDIWidget(
            module: PerfilModule.new,
            child: PerfilPage(),
          ),
          const SobrePage(),
        ],
      ),
    );
  }
}
