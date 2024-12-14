import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';

abstract interface class MovimentacaoRepository {
  Stream<Map<String, List<MovimentacaoModel>>> filter();

  int salvar(MovimentacaoEntity movimentacaoEntity);

  bool remover(int id);
}
