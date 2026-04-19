import 'dart:convert';

import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/dto/resultado_exportacao_backup.dart';
import 'package:budgetopia/common/dto/resultado_importacao_backup.dart';
import 'package:budgetopia/common/enum/modo_importacao_backup.dart';
import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/entity/perfil_entity.dart';
import 'package:budgetopia/config/banco/entity/recorrencia_movimentacao_entity.dart';
import 'package:budgetopia/data/repository/backup/backup_repository.dart';
import 'package:budgetopia/data/service/backup/backup_service.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class BackupRepositoryImpl implements BackupRepository {
  static const int _schemaVersion = 3;
  static const int _firstSupportedSchemaVersion = 1;
  static const JsonEncoder _jsonEncoder = JsonEncoder.withIndent('  ');

  late final BackupService _service = ddi();

  @override
  Future<ResultadoExportacaoBackup> exportarMovimentacoesJson() async {
    final DateTime now = DateTime.now();
    final List<MovimentacaoEntity> movimentacoes = _service.buscarMovimentacoes();
    final List<RecorrenciaMovimentacaoEntity> recorrencias = _service.buscarRecorrencias();
    final PerfilEntity? perfil = _service.buscarPerfil();
    final Map<String, dynamic> payload = <String, dynamic>{
      'schemaVersion': _schemaVersion,
      'exportedAt': now.toUtc().toIso8601String(),
      'totalMovimentacoes': movimentacoes.length,
      'totalRecorrencias': recorrencias.length,
      'perfil': perfil == null ? null : _perfilToJson(perfil),
      'movimentacoes': movimentacoes.map(_toJson).toList(growable: false),
      'recorrencias': recorrencias.map(_recorrenciaToJson).toList(growable: false),
    };

    final String jsonContent = _jsonEncoder.convert(payload);
    final String filePath = await _service.salvarArquivoBackupJson(
      jsonContent: jsonContent,
      exportedAt: now,
    );

    return ResultadoExportacaoBackup(
      filePath: filePath,
      totalMovimentacoes: movimentacoes.length,
      exportedAt: now,
    );
  }

  @override
  Future<ResultadoImportacaoBackup> importarMovimentacoesJson({
    required String filePath,
    required ModoImportacaoBackup modo,
  }) async {
    final String content = await _service.lerArquivoBackupJson(filePath: filePath);
    final dynamic decoded = _decodeJson(content);
    if (decoded is! Map) {
      throw const FormatException(Strings.BACKUP_ESTRUTURA_INVALIDA);
    }

    final Map<String, dynamic> root = decoded.map(
      (dynamic key, dynamic value) => MapEntry(key.toString(), value),
    );

    final int schemaVersion = _readInt(
      root['schemaVersion'],
      fieldName: 'schemaVersion',
    );
    if (schemaVersion < _firstSupportedSchemaVersion || schemaVersion > _schemaVersion) {
      throw FormatException(Strings.backupSchemaNaoSuportado(schemaVersion));
    }

    final dynamic rawMovimentacoes = root['movimentacoes'];
    if (rawMovimentacoes is! List) {
      throw const FormatException(Strings.BACKUP_CAMPO_MOVIMENTACOES_INVALIDO);
    }

    final List<MovimentacaoEntity> importadas = rawMovimentacoes
        .map((dynamic item) => _parseMovimentacao(item))
        .toList(growable: false);
    final List<RecorrenciaMovimentacaoEntity> recorrenciasImportadas = _parseRecorrencias(root, schemaVersion);
    final PerfilEntity? perfilImportado = _parsePerfil(root, schemaVersion);

    if (modo == ModoImportacaoBackup.substituirTudo) {
      final List<MovimentacaoEntity> limpas = importadas.map(_copyWithoutId).toList(growable: false);
      final PerfilEntity? perfilLimpo = perfilImportado == null ? null : _copyPerfilForBackup(perfilImportado);

      _service.substituirDados(
        movimentacoes: limpas,
        recorrencias: recorrenciasImportadas,
        perfil: perfilLimpo,
      );

      return ResultadoImportacaoBackup(
        modo: modo,
        totalNoArquivo: importadas.length,
        totalImportadas: importadas.length,
        totalIgnoradas: 0,
      );
    }

    final Map<int, int> recorrenciaIdMap = _adicionarRecorrenciasNovas(recorrenciasImportadas);
    final Set<String> fingerprints = _service.buscarMovimentacoes().map(_fingerprint).toSet();
    int importadasCount = 0;
    int ignoradasCount = 0;
    final List<MovimentacaoEntity> novas = <MovimentacaoEntity>[];

    for (final MovimentacaoEntity item in importadas) {
      final MovimentacaoEntity normalizada = _copyWithoutId(
        item,
        codigoRecorrencia: _mapCodigoRecorrencia(item.codigoRecorrencia, recorrenciaIdMap),
      );
      final String chave = _fingerprint(normalizada);
      if (fingerprints.add(chave)) {
        novas.add(normalizada);
        importadasCount++;
      } else {
        ignoradasCount++;
      }
    }

    _service.adicionarMovimentacoes(novas);
    if (perfilImportado != null && _service.buscarPerfil() == null) {
      _service.salvarPerfil(_copyPerfilForBackup(perfilImportado));
    }

    return ResultadoImportacaoBackup(
      modo: modo,
      totalNoArquivo: importadas.length,
      totalImportadas: importadasCount,
      totalIgnoradas: ignoradasCount,
    );
  }

  dynamic _decodeJson(String content) {
    try {
      return jsonDecode(content);
    } on FormatException catch (error) {
      throw FormatException(Strings.jsonInvalido(error.message));
    }
  }

  Map<String, dynamic> _toJson(MovimentacaoEntity item) {
    return <String, dynamic>{
      'id': item.id,
      'titulo': item.titulo,
      'valor': item.valor,
      'data': item.data.toUtc().toIso8601String(),
      'tipoMovimentacao': item.tipoMovimentacao,
      'codigoCategoria': item.codigoCategoria,
      'observacao': item.observacao,
      'status': item.status,
      'codigoRecorrencia': item.codigoRecorrencia,
    };
  }

  Map<String, dynamic> _recorrenciaToJson(RecorrenciaMovimentacaoEntity item) {
    return <String, dynamic>{
      'id': item.id,
      'titulo': item.titulo,
      'valorBase': item.valorBase,
      'dataInicio': item.dataInicio.toUtc().toIso8601String(),
      'dataFim': item.dataFim.toUtc().toIso8601String(),
      'tipoMovimentacao': item.tipoMovimentacao,
      'codigoCategoria': item.codigoCategoria,
      'tipoRecorrencia': item.tipoRecorrencia,
      'intervaloDias': item.intervaloDias,
      'observacao': item.observacao,
      'statusPadrao': item.statusPadrao,
      'ativo': item.ativo,
    };
  }

  Map<String, dynamic> _perfilToJson(PerfilEntity item) {
    return <String, dynamic>{
      'nome': item.nome,
      'dataNascimento': item.dataNascimento.toUtc().toIso8601String(),
      'valor': item.valor,
    };
  }

  MovimentacaoEntity _parseMovimentacao(dynamic rawItem) {
    if (rawItem is! Map) {
      throw const FormatException(Strings.BACKUP_ITEM_MOVIMENTACAO_INVALIDO);
    }

    final Map<String, dynamic> map = rawItem.map(
      (dynamic key, dynamic value) => MapEntry(key.toString(), value),
    );

    return MovimentacaoEntity(
      id: map['id'] == null ? 0 : _readInt(map['id'], fieldName: 'id'),
      titulo: _readString(map['titulo'], fieldName: 'titulo'),
      valor: _readDouble(map['valor'], fieldName: 'valor'),
      data: _readDateTime(map['data'], fieldName: 'data'),
      tipoMovimentacao: _readInt(
        map['tipoMovimentacao'],
        fieldName: 'tipoMovimentacao',
      ),
      codigoCategoria: _readInt(
        map['codigoCategoria'],
        fieldName: 'codigoCategoria',
      ),
      observacao: map['observacao'] == null ? '' : _readString(map['observacao'], fieldName: 'observacao'),
      status: map['status'] == null ? false : _readBool(map['status'], fieldName: 'status'),
      codigoRecorrencia: map['codigoRecorrencia'] == null
          ? 0
          : _readInt(map['codigoRecorrencia'], fieldName: 'codigoRecorrencia'),
    );
  }

  List<RecorrenciaMovimentacaoEntity> _parseRecorrencias(Map<String, dynamic> root, int schemaVersion) {
    if (schemaVersion == 1) {
      return const [];
    }

    final dynamic rawRecorrencias = root['recorrencias'];
    if (rawRecorrencias is! List) {
      throw const FormatException(Strings.BACKUP_CAMPO_RECORRENCIAS_INVALIDO);
    }

    return rawRecorrencias.map((dynamic item) => _parseRecorrencia(item)).toList(growable: false);
  }

  PerfilEntity? _parsePerfil(Map<String, dynamic> root, int schemaVersion) {
    if (schemaVersion < 3 || root['perfil'] == null) {
      return null;
    }

    final dynamic rawPerfil = root['perfil'];
    if (rawPerfil is! Map) {
      throw const FormatException(Strings.BACKUP_CAMPO_PERFIL_INVALIDO);
    }

    final Map<String, dynamic> map = rawPerfil.map(
      (dynamic key, dynamic value) => MapEntry(key.toString(), value),
    );

    return PerfilEntity(
      id: 1,
      nome: _readString(map['nome'], fieldName: 'perfil.nome'),
      dataNascimento: _readDateTime(map['dataNascimento'], fieldName: 'perfil.dataNascimento'),
      valor: _readDouble(map['valor'], fieldName: 'perfil.valor'),
    );
  }

  RecorrenciaMovimentacaoEntity _parseRecorrencia(dynamic rawItem) {
    if (rawItem is! Map) {
      throw const FormatException(Strings.BACKUP_ITEM_RECORRENCIA_INVALIDO);
    }

    final Map<String, dynamic> map = rawItem.map(
      (dynamic key, dynamic value) => MapEntry(key.toString(), value),
    );

    return RecorrenciaMovimentacaoEntity(
      id: map['id'] == null ? 0 : _readInt(map['id'], fieldName: 'id'),
      titulo: _readString(map['titulo'], fieldName: 'titulo'),
      valorBase: _readDouble(map['valorBase'], fieldName: 'valorBase'),
      dataInicio: _readDateTime(map['dataInicio'], fieldName: 'dataInicio'),
      dataFim: _readDateTime(map['dataFim'], fieldName: 'dataFim'),
      tipoMovimentacao: _readInt(
        map['tipoMovimentacao'],
        fieldName: 'tipoMovimentacao',
      ),
      codigoCategoria: _readInt(
        map['codigoCategoria'],
        fieldName: 'codigoCategoria',
      ),
      tipoRecorrencia: _readInt(
        map['tipoRecorrencia'],
        fieldName: 'tipoRecorrencia',
      ),
      intervaloDias: map['intervaloDias'] == null ? 0 : _readInt(map['intervaloDias'], fieldName: 'intervaloDias'),
      observacao: map['observacao'] == null ? '' : _readString(map['observacao'], fieldName: 'observacao'),
      statusPadrao: map['statusPadrao'] == null ? false : _readBool(map['statusPadrao'], fieldName: 'statusPadrao'),
      ativo: map['ativo'] == null ? true : _readBool(map['ativo'], fieldName: 'ativo'),
    );
  }

  int _readInt(dynamic value, {required String fieldName}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      final int? parsed = int.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    throw FormatException(Strings.campoBackupInvalido(fieldName));
  }

  double _readDouble(dynamic value, {required String fieldName}) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      final double? parsed = double.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    throw FormatException(Strings.campoBackupInvalido(fieldName));
  }

  bool _readBool(dynamic value, {required String fieldName}) {
    if (value is bool) {
      return value;
    }
    if (value is String) {
      if (value.toLowerCase() == 'true') {
        return true;
      }
      if (value.toLowerCase() == 'false') {
        return false;
      }
    }
    throw FormatException(Strings.campoBackupInvalido(fieldName));
  }

  String _readString(dynamic value, {required String fieldName}) {
    if (value is String) {
      return value;
    }
    throw FormatException(Strings.campoBackupInvalido(fieldName));
  }

  DateTime _readDateTime(dynamic value, {required String fieldName}) {
    if (value is! String) {
      throw FormatException(Strings.campoBackupInvalido(fieldName));
    }
    try {
      return DateTime.parse(value).toLocal();
    } on FormatException {
      throw FormatException(Strings.campoBackupInvalido(fieldName));
    }
  }

  MovimentacaoEntity _copyWithoutId(
    MovimentacaoEntity item, {
    int? codigoRecorrencia,
  }) {
    return MovimentacaoEntity(
      titulo: item.titulo,
      valor: item.valor,
      data: item.data,
      tipoMovimentacao: item.tipoMovimentacao,
      codigoCategoria: item.codigoCategoria,
      observacao: item.observacao,
      status: item.status,
      codigoRecorrencia: codigoRecorrencia ?? item.codigoRecorrencia,
    );
  }

  RecorrenciaMovimentacaoEntity _copyRecorrenciaWithoutId(RecorrenciaMovimentacaoEntity item) {
    return RecorrenciaMovimentacaoEntity(
      titulo: item.titulo,
      valorBase: item.valorBase,
      dataInicio: item.dataInicio,
      dataFim: item.dataFim,
      tipoMovimentacao: item.tipoMovimentacao,
      codigoCategoria: item.codigoCategoria,
      tipoRecorrencia: item.tipoRecorrencia,
      intervaloDias: item.intervaloDias,
      observacao: item.observacao,
      statusPadrao: item.statusPadrao,
      ativo: item.ativo,
    );
  }

  PerfilEntity _copyPerfilForBackup(PerfilEntity item) {
    return PerfilEntity(
      id: 1,
      nome: item.nome,
      dataNascimento: item.dataNascimento,
      valor: item.valor,
    );
  }

  Map<int, int> _adicionarRecorrenciasNovas(List<RecorrenciaMovimentacaoEntity> importadas) {
    if (importadas.isEmpty) {
      return const {};
    }

    final Map<String, RecorrenciaMovimentacaoEntity> existentesPorFingerprint = <String, RecorrenciaMovimentacaoEntity>{
      for (final RecorrenciaMovimentacaoEntity item in _service.buscarRecorrencias())
        _recorrenciaFingerprint(item): item,
    };

    final List<int> idsOriginais = <int>[];
    final List<RecorrenciaMovimentacaoEntity> novas = <RecorrenciaMovimentacaoEntity>[];
    final Map<int, int> idMap = <int, int>{};

    for (final RecorrenciaMovimentacaoEntity item in importadas) {
      final RecorrenciaMovimentacaoEntity? existente = existentesPorFingerprint[_recorrenciaFingerprint(item)];
      if (existente != null) {
        if (item.id > 0) {
          idMap[item.id] = existente.id;
        }
        continue;
      }

      idsOriginais.add(item.id);
      novas.add(_copyRecorrenciaWithoutId(item));
    }

    final List<int> novosIds = _service.adicionarRecorrencias(novas);
    for (int index = 0; index < novosIds.length && index < idsOriginais.length; index++) {
      final int idOriginal = idsOriginais[index];
      if (idOriginal > 0) {
        idMap[idOriginal] = novosIds[index];
      }
    }

    return idMap;
  }

  int _mapCodigoRecorrencia(int codigoRecorrencia, Map<int, int> recorrenciaIdMap) {
    if (codigoRecorrencia <= 0) {
      return 0;
    }

    return recorrenciaIdMap[codigoRecorrencia] ?? 0;
  }

  String _fingerprint(MovimentacaoEntity item) {
    return '${item.titulo.trim().toLowerCase()}|'
        '${item.valor.toStringAsFixed(4)}|'
        '${item.data.toUtc().toIso8601String()}|'
        '${item.tipoMovimentacao}|'
        '${item.codigoCategoria}|'
        '${item.observacao.trim().toLowerCase()}|'
        '${item.status}|'
        '${item.codigoRecorrencia}';
  }

  String _recorrenciaFingerprint(RecorrenciaMovimentacaoEntity item) {
    return '${item.titulo.trim().toLowerCase()}|'
        '${item.valorBase.toStringAsFixed(4)}|'
        '${item.dataInicio.toUtc().toIso8601String()}|'
        '${item.dataFim.toUtc().toIso8601String()}|'
        '${item.tipoMovimentacao}|'
        '${item.codigoCategoria}|'
        '${item.tipoRecorrencia}|'
        '${item.intervaloDias}|'
        '${item.observacao.trim().toLowerCase()}|'
        '${item.statusPadrao}|'
        '${item.ativo}';
  }
}
