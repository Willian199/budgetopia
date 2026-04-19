import 'dart:io';

import 'package:budgetopia/common/components/generics/custom_snackbar.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/dto/resultado_exportacao_backup.dart';
import 'package:budgetopia/common/dto/resultado_importacao_backup.dart';
import 'package:budgetopia/common/enum/modo_importacao_backup.dart';
import 'package:budgetopia/data/repository/backup/backup_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

final class BackupController extends ValueNotifier<bool> {
  BackupController() : super(false);

  late final BackupRepository _repository = ddi();

  Future<void> executarOperacao(Future<void> Function() operacao) async {
    if (value) {
      return;
    }

    value = true;

    try {
      await operacao();
    } finally {
      value = false;
    }
  }

  Future<void> exportarSomenteLocal() async {
    try {
      final ResultadoExportacaoBackup resultado = await _repository.exportarMovimentacoesJson();
      final File arquivoTemporario = File(resultado.filePath);
      final String fileName = p.basename(resultado.filePath);
      final String? filePath = await FilePicker.saveFile(
        dialogTitle: Strings.SALVAR_BACKUP_JSON,
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: const <String>['json'],
        bytes: await arquivoTemporario.readAsBytes(),
      );

      if (filePath == null) {
        CustomSnackBar.informacacao(mensagem: Strings.SALVAMENTO_CANCELADO);
        return;
      }

      if (arquivoTemporario.path != filePath) {
        try {
          await arquivoTemporario.delete();
        } on FileSystemException {
          // Arquivo temporario pode ja ter sido movido/removido pelo seletor.
        }
      }

      CustomSnackBar.sucesso(
        mensagem: Strings.backupSalvo(
          arquivo: p.basename(filePath),
          totalMovimentacoes: resultado.totalMovimentacoes,
        ),
      );
    } on FormatException catch (error) {
      CustomSnackBar.informacacao(mensagem: error.message);
    } catch (_) {
      CustomSnackBar.informacacao(mensagem: Strings.FALHA_EXPORTAR_BACKUP);
    }
  }

  Future<void> exportarECompartilhar() async {
    try {
      final ResultadoExportacaoBackup resultado = await _repository.exportarMovimentacoesJson();

      final ShareResult shareResult = await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[XFile(resultado.filePath)],
          text: Strings.TEXTO_COMPARTILHAR_BACKUP,
        ),
      );

      switch (shareResult.status) {
        case ShareResultStatus.success:
          CustomSnackBar.sucesso(
            mensagem: Strings.BACKUP_COMPARTILHADO_SUCESSO,
          );
          break;
        case ShareResultStatus.dismissed:
          CustomSnackBar.informacacao(
            mensagem: Strings.COMPARTILHAMENTO_CANCELADO,
          );
          break;
        case ShareResultStatus.unavailable:
          CustomSnackBar.informacacao(
            mensagem: Strings.BACKUP_LOCAL_COMPARTILHAMENTO_INDEFINIDO,
          );
          break;
      }
    } on FormatException catch (error) {
      CustomSnackBar.informacacao(mensagem: error.message);
    } catch (_) {
      CustomSnackBar.informacacao(mensagem: Strings.FALHA_EXPORTAR_COMPARTILHAR_BACKUP);
    }
  }

  Future<String?> selecionarArquivoJsonImportacao() async {
    final FilePickerResult? file = await FilePicker.pickFiles(
      dialogTitle: Strings.SELECIONE_ARQUIVO_JSON_BACKUP,
      type: FileType.custom,
      allowedExtensions: const <String>['json'],
    );

    return file?.files.single.path;
  }

  Future<void> importarJson({
    required String filePath,
    required ModoImportacaoBackup modo,
  }) async {
    try {
      final ResultadoImportacaoBackup resultado = await _repository.importarMovimentacoesJson(
        filePath: filePath,
        modo: modo,
      );

      CustomSnackBar.sucesso(
        mensagem: Strings.importacaoBackupConcluida(
          totalImportadas: resultado.totalImportadas,
          totalIgnoradas: resultado.totalIgnoradas,
        ),
      );
    } on FormatException catch (error) {
      CustomSnackBar.informacacao(mensagem: error.message);
    } catch (_) {
      CustomSnackBar.informacacao(mensagem: Strings.FALHA_IMPORTAR_BACKUP);
    }
  }
}
