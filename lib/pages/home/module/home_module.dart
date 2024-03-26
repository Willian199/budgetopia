import 'dart:async';

import 'package:budgetopia/pages/home/controller/home_controller.dart';
import 'package:budgetopia/pages/home/controller/time_line_opacity_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeModule with DDIModule {
  @override
  FutureOr<void> onPostConstruct() {
    registerSingleton(() => HomeController());
    registerSingleton(() => TimeLineOpacityController());
  }
}
