import 'package:budgetopia/ui/detalhamento/module/detalhamento_module.dart';
import 'package:budgetopia/ui/detalhamento/view/detalhamento_page.dart';
import 'package:budgetopia/ui/drawer/module/controler_page_module.dart';
import 'package:budgetopia/ui/home/module/home_module.dart';
import 'package:budgetopia/ui/home/view/home_page.dart';
import 'package:budgetopia/ui/perfil/module/perfil_module.dart';
import 'package:budgetopia/ui/perfil/view/perfil_page.dart';
import 'package:budgetopia/ui/sobre/sobre_page.dart';
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
    return FlutterDDIBuilder(
      module: ControlerPageModule.new,
      child: (_) => PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: instance,
        children: <Widget>[
          FlutterDDIBuilder(
            key: const ValueKey("home"),
            module: HomeModule.new,
            child: (_) {
              return const HomePage(
                key: ValueKey("homekey"),
              );
            },
          ),
          FlutterDDIBuilder(
            module: DetalhamentoModule.new,
            child: (_) => const DetalhamentoPage(),
          ),
          FlutterDDIBuilder(
            module: PerfilModule.new,
            child: (_) => const PerfilPage(),
          ),
          const SobrePage(),
        ],
      ),
    );
  }
}
