import 'dart:io';

import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/config/banco/entity/recorrencia_movimentacao_entity.dart';
import 'package:budgetopia/config/banco/module/store_register.dart';
import 'package:budgetopia/data/service/backup/backup_service.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class BackupServiceImpl implements BackupService {
  static const String _backupDirectoryName = 'budgetopia_backups';

  late final Database _database = ddi.get<Database>();
  late final Box<MovimentacaoEntity> _entity = _database.box<MovimentacaoEntity>();
  late final Box<RecorrenciaMovimentacaoEntity> _recorrenciaEntity = _database.box<RecorrenciaMovimentacaoEntity>();
  late final Box<PerfilEntity> _perfilEntity = _database.box<PerfilEntity>();

  @override
  List<MovimentacaoEntity> buscarMovimentacoes() {
    return _entity.getAll();
  }

  @override
  List<RecorrenciaMovimentacaoEntity> buscarRecorrencias() {
    return _recorrenciaEntity.getAll();
  }

  @override
  PerfilEntity? buscarPerfil() {
    return _perfilEntity.get(1);
  }

  @override
  Future<String> salvarArquivoBackupJson({
    required String jsonContent,
    required DateTime exportedAt,
  }) async {
    final Directory backupDirectory = await _resolveBackupDirectory();
    final String filePath = p.join(backupDirectory.path, _buildFileName(exportedAt));

    await File(filePath).writeAsString(jsonContent, flush: true);
    return filePath;
  }

  @override
  Future<String> lerArquivoBackupJson({
    required String filePath,
  }) async {
    final File file = File(filePath);
    if (!file.existsSync()) {
      throw const FormatException('Arquivo nao encontrado.');
    }

    return file.readAsString();
  }

  @override
  void substituirMovimentacoes(List<MovimentacaoEntity> movimentacoes) {
    _database.runInTransaction(TxMode.write, () {
      _entity.removeAll();
      if (movimentacoes.isNotEmpty) {
        _entity.putMany(movimentacoes);
      }
    });
  }

  @override
  void adicionarMovimentacoes(List<MovimentacaoEntity> movimentacoes) {
    if (movimentacoes.isEmpty) {
      return;
    }

    _database.runInTransaction(TxMode.write, () {
      _entity.putMany(movimentacoes);
    });
  }

  @override
  void substituirDados({
    required List<MovimentacaoEntity> movimentacoes,
    required List<RecorrenciaMovimentacaoEntity> recorrencias,
    PerfilEntity? perfil,
  }) {
    _database.runInTransaction(TxMode.write, () {
      _entity.removeAll();
      _recorrenciaEntity.removeAll();
      _perfilEntity.removeAll();
      if (recorrencias.isNotEmpty) {
        _recorrenciaEntity.putMany(recorrencias);
      }
      if (movimentacoes.isNotEmpty) {
        _entity.putMany(movimentacoes);
      }
      if (perfil != null) {
        _perfilEntity.put(perfil);
      }
    });
  }

  @override
  List<int> adicionarRecorrencias(List<RecorrenciaMovimentacaoEntity> recorrencias) {
    if (recorrencias.isEmpty) {
      return const [];
    }

    return _database.runInTransaction(TxMode.write, () {
      return _recorrenciaEntity.putMany(recorrencias);
    });
  }

  @override
  void salvarPerfil(PerfilEntity perfil) {
    _perfilEntity.put(perfil);
  }

  Future<Directory> _resolveBackupDirectory() async {
    Directory? baseDir;
    try {
      baseDir = await getDownloadsDirectory();
    } catch (_) {
      baseDir = null;
    }

    baseDir ??= await getApplicationDocumentsDirectory();
    final Directory backupDirectory = Directory(
      p.join(baseDir.path, _backupDirectoryName),
    );

    if (!backupDirectory.existsSync()) {
      backupDirectory.createSync(recursive: true);
    }

    return backupDirectory;
  }

  String _buildFileName(DateTime now) {
    return 'budgetopia_movimentacoes_'
        '${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}_'
        '${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}.json';
  }

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }
}
