import 'dart:async';

import 'package:budgetopia/data/repository/detalhamento/detalhamento_repository.dart';
import 'package:budgetopia/ui/detalhamento/state/detalhamento_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DetalhamentoController extends ValueNotifier<DetalhamentoState> with PostConstruct, PreDestroy {
  DetalhamentoController()
    : super(DetalhamentoState(totalEntrada: 0, totalSaida: 0, totalSaldo: 0, valorSaldoObjetivo: 0));

  late final DetalhamentoRepository _detalhamentoRepository = ddi();
  late StreamSubscription<DetalhamentoDados> _refer;

  @override
  FutureOr<void> onPostConstruct() {
    _refer = _detalhamentoRepository.buscarDados().listen((DetalhamentoDados dados) {
      value = DetalhamentoState(
        totalEntrada: dados.resumo.totalEntrada,
        totalSaida: dados.resumo.totalSaida,
        totalSaldo: dados.resumo.totalSaldo,
        valorSaldoObjetivo: dados.valorSaldoObjetivo,
      );
    });
  }

  @override
  FutureOr<void> onPreDestroy() {
    _refer.cancel();
  }
}
