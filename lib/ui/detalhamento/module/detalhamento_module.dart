import 'dart:async';

import 'package:budgetopia/data/repository/detalhamento/detalhamento_repository.dart';
import 'package:budgetopia/data/repository/detalhamento/detalhamento_repository_impl.dart';
import 'package:budgetopia/ui/detalhamento/controller/detalhamento_controller.dart';
import 'package:budgetopia/ui/detalhamento/controller/grafico_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class DetalhamentoModule with DDIModule {
  @override
  void onPostConstruct() {
    Future.wait([
      application<DetalhamentoRepository>(DetalhamentoRepositoryImpl.new),
      application(DetalhamentoController.new),
      application(GraficoController.new),
    ]);
  }
}
