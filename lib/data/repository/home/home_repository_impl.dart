import 'dart:async';

import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/repository/home/home_repository.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/data/repository/recorrencia/recorrencia_repository.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeRepositoryImpl implements HomeRepository {
  late final MovimentacaoRepository _movimentacaoRepository = ddi();
  late final RecorrenciaRepository _recorrenciaRepository = ddi();

  Map<String, List<MovimentacaoModel>> _movimentacoesPorMes = {};
  Map<String, List<MovimentacaoModel>> _ultimoSnapshotPersistido = {};

  List<MovimentacaoModel> _movimentacoesDoMesSelecionado = [];
  List<MovimentacaoModel> _movimentacoesDaAbaSelecionada = [];

  @override
  List<MovimentacaoModel> get movimentacoesMesSelecionado => List.unmodifiable(_movimentacoesDoMesSelecionado);

  @override
  List<MovimentacaoModel> get movimentacoesPorAba => List.unmodifiable(_movimentacoesDaAbaSelecionada);

  @override
  Stream<Map<String, List<MovimentacaoModel>>> buscarDadosMovimentacao() {
    return Stream.multi((controller) {
      late final StreamSubscription<Map<String, List<MovimentacaoModel>>> subMovimentacoes;
      late final StreamSubscription<dynamic> subRecorrencias;

      void emitSnapshot() {
        controller.add(_mesclarComRecorrencias(_ultimoSnapshotPersistido));
      }

      subMovimentacoes = _movimentacaoRepository.buscarDadosMovimentacao().listen(
        (event) {
          _ultimoSnapshotPersistido = event;
          emitSnapshot();
        },
        onError: controller.addError,
      );

      subRecorrencias = _recorrenciaRepository.buscarRecorrencias().listen(
        (_) {
          emitSnapshot();
        },
        onError: controller.addError,
      );

      controller.onCancel = () async {
        await subMovimentacoes.cancel();
        await subRecorrencias.cancel();
      };
    });
  }

  Map<String, List<MovimentacaoModel>> _mesclarComRecorrencias(Map<String, List<MovimentacaoModel>> event) {
    final DateTime now = DateTime.now();
    final DateTime inicio = now.subtractMonths(11).firstDayOfMonth;
    final DateTime fim = DateTime(now.year, now.month + 2, 0);

    final Map<String, List<MovimentacaoModel>> merged = {
      for (final MapEntry<String, List<MovimentacaoModel>> entry in event.entries) entry.key: List.of(entry.value),
    };

    for (final DateTime mes in _recorrenciaRepository.buscarMesesComSugestoes(inicio: inicio, fim: fim)) {
      final String key = _formatMesAno(mes);
      merged.putIfAbsent(key, () => []);
    }

    final List<String> chavesOrdenadas = merged.keys.toList()..sort(_compararMesAno);

    _movimentacoesPorMes = {
      for (final String key in chavesOrdenadas)
        key: List<MovimentacaoModel>.of(merged[key]!)..sort(_compararMovimentacao),
    };

    return _movimentacoesPorMes;
  }

  @override
  List<MovimentacaoModel> filtrarMovimentacao(int posicao, TipoRegistroEnum tabSelecionada) {
    if (_movimentacoesPorMes.isEmpty) {
      _movimentacoesDoMesSelecionado = [];
      _movimentacoesDaAbaSelecionada = [];
      return const [];
    }

    final int posicaoAjustada = posicao.clamp(0, _movimentacoesPorMes.length - 1).toInt();
    final MapEntry<String, List<MovimentacaoModel>> entry = _movimentacoesPorMes.entries.elementAt(posicaoAjustada);

    final DateTime mesSelecionado = _parseMesAno(entry.key);
    final List<MovimentacaoModel> sugestoes = _recorrenciaRepository.buscarSugestoesParaMes(mesSelecionado);

    _movimentacoesDoMesSelecionado = [
      ...entry.value,
      ...sugestoes.where((sugestao) => !_containsSugestao(entry.value, sugestao)),
    ]..sort(_compararMovimentacao);

    filtrarMovimentacaoAba(tabSelecionada);

    return List.unmodifiable(_movimentacoesDoMesSelecionado);
  }

  @override
  void filtrarMovimentacaoAba(TipoRegistroEnum tabSelecionada) {
    _movimentacoesDaAbaSelecionada = switch (tabSelecionada) {
      TipoRegistroEnum.todos => List.of(_movimentacoesDoMesSelecionado),
      TipoRegistroEnum.entrada =>
        _movimentacoesDoMesSelecionado
            .where((element) => element.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id)
            .toList(),
      TipoRegistroEnum.saida =>
        _movimentacoesDoMesSelecionado
            .where((element) => element.tipoMovimentacao == TipoMovimentacaoEnum.saida.id)
            .toList(),
    };
  }

  @override
  bool confirmarSugestao(MovimentacaoModel sugestao) {
    if (!sugestao.sugestao || sugestao.codigoRecorrencia <= 0) {
      return false;
    }

    final bool jaExiste = _recorrenciaRepository.existeMovimentacaoConfirmada(
      recorrenciaId: sugestao.codigoRecorrencia,
      data: sugestao.data,
    );

    if (jaExiste) {
      return false;
    }

    final MovimentacaoEntity entity = MovimentacaoEntity(
      titulo: sugestao.titulo,
      valor: sugestao.valor,
      observacao: sugestao.observacao ?? '',
      data: sugestao.data,
      codigoCategoria: sugestao.codigoCategoria,
      tipoMovimentacao: sugestao.tipoMovimentacao,
      status: sugestao.status,
      codigoRecorrencia: sugestao.codigoRecorrencia,
    );

    return _movimentacaoRepository.salvar(entity) > 0;
  }

  bool _containsSugestao(List<MovimentacaoModel> movimentacoes, MovimentacaoModel sugestao) {
    return movimentacoes.any((movimentacao) {
      return movimentacao.codigoRecorrencia == sugestao.codigoRecorrencia &&
          movimentacao.data.year == sugestao.data.year &&
          movimentacao.data.month == sugestao.data.month &&
          movimentacao.data.day == sugestao.data.day;
    });
  }

  int _compararMovimentacao(MovimentacaoModel a, MovimentacaoModel b) {
    final int dateCompare = a.data.compareTo(b.data);
    if (dateCompare != 0) {
      return dateCompare;
    }

    return a.id.compareTo(b.id);
  }

  int _compararMesAno(String a, String b) {
    final DateTime? dataA = _tryParseMesAno(a);
    final DateTime? dataB = _tryParseMesAno(b);

    if (dataA == null && dataB == null) {
      return a.compareTo(b);
    }
    if (dataA == null) {
      return 1;
    }
    if (dataB == null) {
      return -1;
    }

    return dataA.compareTo(dataB);
  }

  String _formatMesAno(DateTime date) => '${date.getFormattedMonth()}/${date.year}';

  DateTime _parseMesAno(String key) {
    final DateTime? date = _tryParseMesAno(key);
    if (date == null) {
      throw FormatException('Mes/ano invalido', key);
    }

    return date;
  }

  DateTime? _tryParseMesAno(String key) {
    final List<String> parts = key.split('/');
    if (parts.length != 2) {
      return null;
    }

    final int? year = int.tryParse(parts[1]);
    final int? month = _parseMes(parts[0]);

    if (year == null || month == null) {
      return null;
    }

    return DateTime(year, month);
  }

  int? _parseMes(String value) {
    return switch (value) {
      'Jan' => 1,
      'Fev' => 2,
      'Mar' => 3,
      'Abr' => 4,
      'Mai' => 5,
      'Jun' => 6,
      'Jul' => 7,
      'Ago' => 8,
      'Set' => 9,
      'Out' => 10,
      'Nov' => 11,
      'Dez' => 12,
      _ => null,
    };
  }
}
