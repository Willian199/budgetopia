import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/repository/home/home_repository.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeRepositoryImpl implements HomeRepository {
  late final MovimentacaoRepository _movimentacaoRepository = ddi();

  late Map<String, List<MovimentacaoModel>> _todasMovimentacoes = {};

  late List<MovimentacaoModel> _movimentacoesMesSelecionado = [];

  late List<MovimentacaoModel> _registrosAbaMovimentacao = [];

  @override
  List<MovimentacaoModel> get movimentacoesMesSelecionado => _movimentacoesMesSelecionado;

  @override
  List<MovimentacaoModel> get movimentacoesPorAba => _registrosAbaMovimentacao;

  @override
  Stream<Map<String, List<MovimentacaoModel>>> buscarDadosMovimentacao() {
    return _movimentacaoRepository.buscarDadosMovimentacao().map((Map<String, List<MovimentacaoModel>> event) {
      _todasMovimentacoes = event;
      return event;
    });
  }

  @override
  List<MovimentacaoModel> filtrarMovimentacao(int posicao, TipoRegistroEnum tabSelecionada) {
    _movimentacoesMesSelecionado = _todasMovimentacoes.entries.elementAt(posicao).value;

    filtrarMovimentacaoAba(tabSelecionada);

    return _movimentacoesMesSelecionado;
  }

  @override
  void filtrarMovimentacaoAba(TipoRegistroEnum tabSelecionada) {
    _registrosAbaMovimentacao = switch (tabSelecionada) {
      TipoRegistroEnum.todos => _movimentacoesMesSelecionado,
      TipoRegistroEnum.entrada =>
        _movimentacoesMesSelecionado.where((element) => element.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id).toList(),
      TipoRegistroEnum.saida => _movimentacoesMesSelecionado.where((element) => element.tipoMovimentacao == TipoMovimentacaoEnum.saida.id).toList(),
    };
  }
}
