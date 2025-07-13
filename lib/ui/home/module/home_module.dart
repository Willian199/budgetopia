import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/controller/selecao_horizontal_controller.dart';
import 'package:budgetopia/data/repository/home/home_repository.dart';
import 'package:budgetopia/data/repository/home/home_repository_impl.dart';
import 'package:budgetopia/ui/home/case/home_case.dart';
import 'package:budgetopia/ui/home/controller/home_controller.dart';
import 'package:budgetopia/ui/home/controller/time_line_opacity_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeModule with DDIModule {
  @override
  void onPostConstruct() {
    Future.wait([
      application(HomeCase.new),
      application(
        SelecaoHorizontalController<HomeCase>.new,
        qualifier: '$HomeModule${SelecaoHorizontalController<HomeCase>}',
      ),
      singleton(TimeLineOpacityController.new),
      register(
        factory: ApplicationFactory(builder: HomeController.new.builder),
      ),
      application<HomeRepository>(HomeRepositoryImpl.new),
    ]);
  }
}
