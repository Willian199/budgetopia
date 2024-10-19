import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/generics/custom_error_module.dart';
import 'package:budgetopia/common/components/generics/custom_loader_module.dart';
import 'package:budgetopia/common/constantes/qualifiers.dart';
import 'package:budgetopia/config/banco/module/object_box.dart';
import 'package:budgetopia/config/banco/module/store_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

final class StartModule with DDIModule {
  @override
  Future<void> onPostConstruct() async {
    registerObject<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>());

    final AdaptiveThemeMode themeMode = await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.system;

    Future.wait([
      registerObject(themeMode, qualifier: Qualifier.adaptive_theme_mode),
      registerObject(
        switch (themeMode) {
          AdaptiveThemeMode.system => WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark,
          AdaptiveThemeMode.light => false,
          AdaptiveThemeMode.dark => true
        },
        qualifier: Qualifier.dark_mode,
      ),
      registerApplication(ZoomDrawerController.new),
      registerApplication(PageController.new),
      register<ErrorModuleInterface>(
        factory: ScopeFactory.dependent(
            builder: (AsyncSnapshot snapshot) {
          return CustomErrorModule(snapshot);
        }.builder),
      ),
      register<LoaderModuleInterface>(
        factory: ScopeFactory.dependent(
          builder: CustomLoaderModule.new.builder,
        ),
      ),
    ]);

    await registerSingleton<Database>(
      () async => ObjectBox.create(),
      interceptors: [DatabaseInterceptor.new],
    );
  }
}
