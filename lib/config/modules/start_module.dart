import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class StartModule with DDIModule {
  @override
  Future<void> onPostConstruct() async {
    registerObject<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>());

    await registerSingleton<AdaptiveThemeMode>(
      () async {
        final AdaptiveThemeMode? themeMode = await AdaptiveTheme.getThemeMode();

        return themeMode ?? AdaptiveThemeMode.system;
      },
      qualifier: Qualifier.adaptive_theme_mode,
    );

    registerObject(
      switch (ddi.get<AdaptiveThemeMode>(qualifier: Qualifier.adaptive_theme_mode)) {
        AdaptiveThemeMode.system => WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark,
        AdaptiveThemeMode.light => false,
        AdaptiveThemeMode.dark => true
      },
      qualifier: Qualifier.dark_mode,
    );

    registerApplication(ZoomDrawerController.new);
    registerApplication(PageController.new);
  }
}
