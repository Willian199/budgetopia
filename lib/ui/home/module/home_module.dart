import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/controller/selecao_horizontal_controller.dart';
import 'package:budgetopia/ui/home/controller/home_controller.dart';
import 'package:budgetopia/ui/home/controller/time_line_opacity_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeModule with DDIModule {
  @override
  void onPostConstruct() {
    Future.wait([
      registerComponent(SelecaoHorizontalController.new),
      registerSingleton(TimeLineOpacityController.new),
      register(
        factory: ScopeFactory.application(builder: HomeController.new.builder),
      ),
    ]);
  }
}
