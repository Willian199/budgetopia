import 'dart:async';

import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository_impl.dart';
import 'package:budgetopia/data/repository/perfil/perfil_repository.dart';
import 'package:budgetopia/ui/detalhamento/state/detalhamento_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DetalhamentoController with DDIEventSender<DetalhamentoState>, PostConstruct, PreDestroy {
  late final MovimentacaoRepository _movimentacaoRepository = ddi();
  late final PerfilRepository _perfilService = ddi();

  double get valorSaldoObjetivo => _perfilService.getFirst?.valor ?? 0;

  late StreamSubscription<MovimentacaoDados> _refer;

  @override
  FutureOr<void> onPostConstruct() {
    _refer = _movimentacaoRepository.buscarDadosDetalhamento().listen((MovimentacaoDados dados) {
      final (_, detalhamento) = dados;

      fire(
        DetalhamentoState(
          totalEntrada: detalhamento.totalEntrada,
          totalSaida: detalhamento.totalSaida,
          totalSaldo: detalhamento.totalSaldo,
        ),
      );
    });
  }

  @override
  FutureOr<void> onPreDestroy() {
    _refer.cancel();
  }
}
