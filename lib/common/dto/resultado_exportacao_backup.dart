final class ResultadoExportacaoBackup {
  ResultadoExportacaoBackup({
    required this.filePath,
    required this.totalMovimentacoes,
    required this.exportedAt,
  });

  final String filePath;
  final int totalMovimentacoes;
  final DateTime exportedAt;
}
