import 'dart:async';

import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/repository/detalhamento/detalhamento_repository.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/data/repository/perfil/perfil_repository.dart';
import 'package:budgetopia/ui/home/model/grafico_model.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class DetalhamentoRepositoryImpl implements DetalhamentoRepository {
  late final MovimentacaoRepository _movimentacaoRepository = ddi();
  late final PerfilRepository _perfilRepository = ddi();

  @override
  Stream<DetalhamentoDados> buscarDados() {
    return Stream.multi((controller) {
      Map<String, List<MovimentacaoModel>> movimentacoes = const {};
      PerfilEntity? perfil = _perfilRepository.getFirst;
      bool recebeuMovimentacoes = false;

      void emitSnapshot() {
        if (!recebeuMovimentacoes) {
          return;
        }

        controller.add(_criarDados(movimentacoes, perfil));
      }

      final StreamSubscription<Map<String, List<MovimentacaoModel>>> movimentacoesSubscription = _movimentacaoRepository
          .buscarDadosMovimentacao()
          .listen(
            (event) {
              movimentacoes = event;
              recebeuMovimentacoes = true;
              emitSnapshot();
            },
            onError: controller.addError,
          );

      final StreamSubscription<PerfilEntity?> perfilSubscription = _perfilRepository.watchFirst.listen(
        (event) {
          perfil = event;
          emitSnapshot();
        },
        onError: controller.addError,
      );

      controller.onCancel = () async {
        await movimentacoesSubscription.cancel();
        await perfilSubscription.cancel();
      };
    });
  }

  DetalhamentoDados _criarDados(
    Map<String, List<MovimentacaoModel>> movimentacoesPorMes,
    PerfilEntity? perfil,
  ) {
    final List<GraficoModel> saidas = [];
    final List<GraficoModel> entradas = [];
    final List<GraficoModel> saldo = [];

    double totalEntrada = 0;
    double totalSaida = 0;

    int posicao = 2;
    for (final MapEntry(:key, :value) in movimentacoesPorMes.entries) {
      double entrada = 0;
      double saida = 0;

      for (final MovimentacaoModel item in value) {
        if (item.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id) {
          entrada += item.valor;
        } else {
          saida += item.valor;
        }
      }

      saidas.add(GraficoModel(index: posicao.toDouble(), legenda: key, valor: saida));
      entradas.add(GraficoModel(index: posicao.toDouble(), legenda: key, valor: entrada));
      saldo.add(GraficoModel(index: posicao.toDouble(), legenda: key, valor: entrada - saida));

      posicao++;
      totalEntrada += entrada;
      totalSaida += saida;
    }

    return (
      grafico: (saidas: saidas, entradas: entradas, saldo: saldo),
      resumo: (
        totalEntrada: totalEntrada,
        totalSaida: totalSaida,
        totalSaldo: totalEntrada - totalSaida,
      ),
      valorSaldoObjetivo: perfil?.valor ?? 0,
    );
  }
}
