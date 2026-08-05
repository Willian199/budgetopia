import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';

abstract interface class MovimentacaoRepository {
  Stream<Map<String, List<MovimentacaoModel>>> buscarDadosMovimentacao();

  int salvar(MovimentacaoEntity movimentacaoEntity);

  List<int> salvarTodos(List<MovimentacaoEntity> movimentacoes);

  bool remover(int id);
}
