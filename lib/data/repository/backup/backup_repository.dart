import 'package:budgetopia/common/enum/modo_importacao_backup.dart';
import 'package:budgetopia/common/dto/resultado_exportacao_backup.dart';
import 'package:budgetopia/common/dto/resultado_importacao_backup.dart';

abstract interface class BackupRepository {
  Future<ResultadoExportacaoBackup> exportarMovimentacoesJson();

  Future<ResultadoImportacaoBackup> importarMovimentacoesJson({
    required String filePath,
    required ModoImportacaoBackup modo,
  });
}
