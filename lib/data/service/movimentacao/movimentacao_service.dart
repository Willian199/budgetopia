import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/service/movimentacao/movimentacao_service_impl.dart';

abstract interface class MovimentacaoService {
  Stream<MovimentacaoDados> buscarDadosDetalhamento();

  Stream<Map<String, List<MovimentacaoModel>>> buscarDadosMovimentacao();

  int salvar(MovimentacaoEntity movimentacaoEntity);

  bool remover(int id);
}
