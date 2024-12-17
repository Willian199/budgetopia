import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository_impl.dart';

abstract interface class MovimentacaoRepository {
  Stream<MovimentacaoDados> buscarDadosDetalhamento();

  Stream<Map<String, List<MovimentacaoModel>>> buscarDadosMovimentacao();

  int salvar(MovimentacaoEntity movimentacaoEntity);

  bool remover(int id);
}
