import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/config/banco/entity/recorrencia_movimentacao_entity.dart';

abstract interface class BackupService {
  List<MovimentacaoEntity> buscarMovimentacoes();

  List<RecorrenciaMovimentacaoEntity> buscarRecorrencias();

  PerfilEntity? buscarPerfil();

  Future<String> salvarArquivoBackupJson({
    required String jsonContent,
    required DateTime exportedAt,
  });

  Future<String> lerArquivoBackupJson({
    required String filePath,
  });

  void substituirMovimentacoes(List<MovimentacaoEntity> movimentacoes);

  void adicionarMovimentacoes(List<MovimentacaoEntity> movimentacoes);

  void substituirDados({
    required List<MovimentacaoEntity> movimentacoes,
    required List<RecorrenciaMovimentacaoEntity> recorrencias,
    PerfilEntity? perfil,
  });

  List<int> adicionarRecorrencias(List<RecorrenciaMovimentacaoEntity> recorrencias);

  void salvarPerfil(PerfilEntity perfil);
}
