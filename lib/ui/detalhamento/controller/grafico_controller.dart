import 'dart:async';

import 'package:budgetopia/data/service/movimentacao/movimentacao_service.dart';
import 'package:budgetopia/data/service/movimentacao/movimentacao_service_impl.dart';
import 'package:budgetopia/ui/detalhamento/state/grafico_state.dart';
import 'package:budgetopia/ui/perfil/controller/salvar_perfil_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class GraficoController with DDIEventSender<GraficoState>, PostConstruct, PreDestroy {
  late final MovimentacaoService _movimentacaoService = ddi();
  late final PerfilController _perfilController = ddi();

  late StreamSubscription<MovimentacaoDados> _refer;

  double get valorSaldoObjetivo => _perfilController.registroSalvo?.valor ?? 0;

  @override
  FutureOr<void> onPostConstruct() {
    _refer = _movimentacaoService.buscarDadosDetalhamento().listen((MovimentacaoDados dados) {
      final (grafico, _) = dados;

      fire(
        GraficoState(
          saidas: grafico.saidas,
          entradas: grafico.entradas,
          saldo: grafico.saldo,
          valorSaldoObjetivo: _perfilController.registroSalvo?.valor ?? 0,
        ),
      );
    });
  }

  @override
  FutureOr<void> onPreDestroy() {
    _refer.cancel();
  }
}
