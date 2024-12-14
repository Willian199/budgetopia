import 'dart:async';

import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/config/banco/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/ui/detalhamento/state/detalhamento_state.dart';
import 'package:budgetopia/ui/detalhamento/state/grafico_state.dart';
import 'package:budgetopia/ui/home/model/grafico_model.dart';
import 'package:budgetopia/ui/perfil/controller/salvar_perfil_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DetalhamentoController with DDIEventSender<GraficoState>, PostConstruct, PreDestroy {
  DetalhamentoController();

  late final MovimentacaoRepository _movimentacaoRepository = ddi();
  late final PerfilController _perfilController = ddi();

  @override
  GraficoState get state => super.state ?? GraficoState();

  late StreamSubscription<Map<String, List<MovimentacaoModel>>> _refer;

  double get valorSaldoObjetivo => _perfilController.registroSalvo?.valor ?? 0;

  @override
  FutureOr<void> onPostConstruct() {
    _refer = _movimentacaoRepository.filter().listen((Map<String, List<MovimentacaoModel>> event) {
      final List<GraficoModel> saidas = [];
      final List<GraficoModel> entradas = [];
      final List<GraficoModel> saldo = [];

      double totalEntrada = 0;
      double totalSaida = 0;

      if (event.isNotEmpty) {
        int pos = 2;
        for (final MapEntry(:key, :value) in event.entries) {
          double entrada = 0;
          double saida = 0;
          for (final MovimentacaoModel item in value) {
            if (item.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id) {
              entrada += item.valor;
            } else {
              saida += item.valor;
            }
          }

          saidas.add(GraficoModel(index: pos.toDouble(), legenda: key, valor: saida));
          entradas.add(GraficoModel(index: pos.toDouble(), legenda: key, valor: entrada));
          saldo.add(GraficoModel(index: pos.toDouble(), legenda: key, valor: entrada - saida));
          pos++;
          totalEntrada += entrada;
          totalSaida += saida;
        }
      }

      fire(
        GraficoState(
          saidas: saidas,
          entradas: entradas,
          saldo: saldo,
        ),
      );

      ddiEvent.fire<DetalhamentoState>(
        DetalhamentoState(
          totalEntrada: totalEntrada,
          totalSaida: totalSaida,
          totalSaldo: totalEntrada - totalSaida,
        ),
      );
    });
  }

  @override
  FutureOr<void> onPreDestroy() {
    _refer.cancel();
  }
}
