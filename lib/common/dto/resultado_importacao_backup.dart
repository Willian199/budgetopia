import 'package:budgetopia/common/enum/modo_importacao_backup.dart';

final class ResultadoImportacaoBackup {
  ResultadoImportacaoBackup({
    required this.modo,
    required this.totalNoArquivo,
    required this.totalImportadas,
    required this.totalIgnoradas,
  });

  final ModoImportacaoBackup modo;
  final int totalNoArquivo;
  final int totalImportadas;
  final int totalIgnoradas;
}
