import 'package:animations/animations.dart';
import 'package:budgetopia/common/constantes/integer.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/ui/drawer/view/widget/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DrawerItemPage extends StatefulWidget {
  const DrawerItemPage({super.key});

  @override
  State<DrawerItemPage> createState() => _DrawerItemPageState();
}

class _DrawerItemPageState extends State<DrawerItemPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building DrawerItemPage');
    return SizedBox(
      child: ValueListenableBuilder<DrawerState>(
        valueListenable: ddi.get<ZoomDrawerController>().stateNotifier!,
        builder: (BuildContext context, DrawerState state, Widget? child) {
          switch (state) {
            case DrawerState.closed:
              return const SizedBox();
            case DrawerState.opening:
              break;
            case DrawerState.closing:
              _controller.reverse();
              break;
            case DrawerState.open:
              _controller.forward();

              break;
          }
          FocusManager.instance.primaryFocus?.unfocus();
          return AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return FadeScaleTransition(
                animation: _controller,
                child: child,
              );
            },
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DrawerTile(
                  Icons.home,
                  Strings.HOME,
                  Integer.ZERO,
                ),
                DrawerTile(
                  Icons.show_chart,
                  Strings.DETALHES,
                  Integer.UM,
                ),
                DrawerTile(
                  Icons.person,
                  Strings.PERFIL,
                  Integer.DOIS,
                ),
                DrawerTile(
                  Icons.info_rounded,
                  Strings.SOBRE,
                  Integer.TRES,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
