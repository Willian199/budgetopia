import 'dart:async';

import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository_impl.dart';
import 'package:budgetopia/ui/detalhamento/state/grafico_state.dart';
import 'package:budgetopia/ui/perfil/case/salvar_perfil_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class GraficoController extends ValueNotifier<GraficoState> with PostConstruct, PreDestroy {
  GraficoController() : super(GraficoState());
  late final MovimentacaoRepository _movimentacaoRepository = ddi();
  late final PerfilCase _perfilController = ddi();

  late StreamSubscription<MovimentacaoDados> _refer;

  double get valorSaldoObjetivo => _perfilController.registroSalvo?.valor ?? 0;

  @override
  FutureOr<void> onPostConstruct() {
    _refer = _movimentacaoRepository.buscarDadosDetalhamento().listen((MovimentacaoDados dados) {
      final (grafico, _) = dados;

      value = GraficoState(
        saidas: grafico.saidas,
        entradas: grafico.entradas,
        saldo: grafico.saldo,
        valorSaldoObjetivo: _perfilController.registroSalvo?.valor ?? 0,
      );
    });
  }

  @override
  FutureOr<void> onPreDestroy() {
    _refer.cancel();
  }
}
