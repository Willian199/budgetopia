import 'package:budgetopia/config/banco/entity/recorrencia_movimentacao_entity.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';

abstract interface class RecorrenciaRepository {
  Stream<List<RecorrenciaMovimentacaoEntity>> buscarRecorrencias();

  int salvar(RecorrenciaMovimentacaoEntity recorrenciaEntity);

  bool remover(int id);

  RecorrenciaMovimentacaoEntity? buscarPorId(int id);

  List<DateTime> buscarMesesComSugestoes({
    required DateTime inicio,
    required DateTime fim,
  });

  List<MovimentacaoModel> buscarSugestoesParaMes(DateTime mesReferencia);

  bool existeMovimentacaoConfirmada({
    required int recorrenciaId,
    required DateTime data,
  });
}
