import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/entity/recorrencia_movimentacao_entity.dart';

abstract interface class RecorrenciaService {
  Stream<List<RecorrenciaMovimentacaoEntity>> buscarRecorrencias();

  List<RecorrenciaMovimentacaoEntity> listarRecorrenciasAtivas();

  int salvar(RecorrenciaMovimentacaoEntity recorrenciaEntity);

  bool remover(int id);

  RecorrenciaMovimentacaoEntity? buscarPorId(int id);

  List<MovimentacaoEntity> buscarMovimentacoesPorRecorrencia({
    required int recorrenciaId,
    DateTime? ateData,
    int limit = 12,
  });

  bool existeMovimentacaoConfirmada({
    required int recorrenciaId,
    required DateTime data,
  });
}
