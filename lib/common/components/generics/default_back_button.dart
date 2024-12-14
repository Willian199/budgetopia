import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DefaultBackButton extends StatefulWidget {
  const DefaultBackButton({super.key});

  @override
  State<DefaultBackButton> createState() => DefaultBackButtonState();
}

class DefaultBackButtonState extends State<DefaultBackButton> with TickerProviderStateMixin, DDIInject<ZoomDrawerController> {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = AdaptiveTheme.of(context).theme;

    if (instance.isOpen!()) {
      _animationController.forward();
    }

    return ValueListenableBuilder<DrawerState>(
      valueListenable: instance.stateNotifier!,
      builder: (BuildContext context, DrawerState state, Widget? child) {
        switch (state) {
          case DrawerState.open:
          case DrawerState.closing:
            break;
          case DrawerState.opening:
            _animationController.forward();
            break;

          case DrawerState.closed:
            _animationController.reverse();
            break;
        }

        return child!;
      },
      child: SizedBox(
        height: 30,
        width: 30,
        child: IconButton(
          style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.transparent),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            instance.toggle?.call();
          },
          icon: AnimatedIcon(
            color: tema.colorScheme.onTertiaryContainer,
            icon: AnimatedIcons.menu_close,
            progress: _animationController,
          ),
        ),
      ),
    );
  }
}
