import 'package:budgetopia/common/components/generics/degrade.dart';
import 'package:budgetopia/common/constantes/double.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/ui/drawer/view/controller_page.dart';
import 'package:budgetopia/ui/drawer/view/widget/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Building DrawerPage');

    final ColorScheme colorScheme = context.colorScheme;

    final List<Color> degrade = ddi.get<bool>(qualifier: Qualifier.dark_mode)
        ? <Color>[
            colorScheme.primaryContainer,
            colorScheme.tertiary,
          ]
        : <Color>[
            colorScheme.tertiary,
            colorScheme.onPrimary,
          ];

    return Container(
      decoration: Degrade.efeitoDegrade(
        cores: degrade,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: ZoomDrawer(
        controller: ddi.get<ZoomDrawerController>(),
        mainScreenTapClose: true,
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 100),
        mainScreen: const ControllerPage(),
        menuScreen: const Padding(
          padding: EdgeInsets.only(left: Double.DEZ),
          child: DrawerItem(),
        ),
        borderRadius: 30.0,
        showShadow: true,
        //style: DrawerStyle.style1,
        drawerShadowsBackgroundColor: colorScheme.tertiaryContainer,
        slideWidth: MediaQuery.sizeOf(context).width * 0.65,
      ),
    );
  }
}
