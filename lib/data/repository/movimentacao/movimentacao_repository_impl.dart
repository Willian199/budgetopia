import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/data/service/movimentacao/movimentacao_service.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class MovimentacaoRepositoryImpl implements MovimentacaoRepository {
  late final MovimentacaoService _movimentacaoService = ddi();

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

  @override
  List<int> salvarTodos(List<MovimentacaoEntity> movimentacoes) {
    return _movimentacaoService.salvarTodos(movimentacoes);
  }
}
