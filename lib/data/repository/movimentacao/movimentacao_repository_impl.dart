import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/data/service/movimentacao/movimentacao_service.dart';
import 'package:budgetopia/ui/home/model/grafico_model.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

typedef Grafico = ({List<GraficoModel> saidas, List<GraficoModel> entradas, List<GraficoModel> saldo});

typedef Detalhamento = ({double totalEntrada, double totalSaida, double totalSaldo});

typedef MovimentacaoDados = (Grafico grafico, Detalhamento detalhamento);

final class MovimentacaoRepositoryImpl implements MovimentacaoRepository {
  late final MovimentacaoService _movimentacaoService = ddi();

  @override
  Stream<MovimentacaoDados> buscarDadosDetalhamento() {
    return _movimentacaoService.filter().map((Map<String, List<MovimentacaoModel>> event) {
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

      final Grafico grafico = (
        saidas: saidas,
        entradas: entradas,
        saldo: saldo,
      );

      final Detalhamento detalhamento = (
        totalEntrada: totalEntrada,
        totalSaida: totalSaida,
        totalSaldo: totalEntrada - totalSaida,
      );

      return (grafico, detalhamento);
    });
  }

  @override
  Stream<Map<String, List<MovimentacaoModel>>> buscarDadosMovimentacao() {
    return _movimentacaoService.filter();
  }

  @override
  bool remover(int id) {
    return _movimentacaoService.remover(id);
  }

  @override
  int salvar(MovimentacaoEntity movimentacaoEntity) {
    return _movimentacaoService.salvar(movimentacaoEntity);
  }
}
