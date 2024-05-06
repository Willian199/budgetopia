import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/pages/drawer/widget/drawer_item_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:lottie/lottie.dart';

class DrawerItem extends StatefulWidget {
  const DrawerItem({super.key});

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    if (ddi.get(qualifier: Qualifier.dark_mode)) {
      _backgroundController.forward();
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = AdaptiveTheme.of(context).theme.colorScheme;

    return Stack(
      children: [
        const DrawerItemPage(),
        Positioned(
          top: 100,
          left: 15,
          child: GestureDetector(
            onTap: () {
              if (_backgroundController.isCompleted) {
                _backgroundController.reverse();
                AdaptiveTheme.of(context).setLight();
                ddi.refreshObject(false, qualifier: Qualifier.dark_mode);
              } else {
                _backgroundController.forward();
                AdaptiveTheme.of(context).setDark();
                ddi.refreshObject(true, qualifier: Qualifier.dark_mode);
              }
            },
            child: Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.tertiaryContainer,
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Lottie.asset(
                "assets/lottie/toggle_day_night.json",
                fit: BoxFit.fill,
                frameRate: FrameRate.max,
                controller: _backgroundController,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
