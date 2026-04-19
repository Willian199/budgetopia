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

  late Map<String, List<MovimentacaoModel>> _todasMovimentacoes = {};

  late List<MovimentacaoModel> _movimentacoesMesSelecionado = [];

  late List<MovimentacaoModel> _registrosAbaMovimentacao = [];
  Map<String, List<MovimentacaoModel>> _ultimoSnapshotMovimentacoes = {};

  @override
  List<MovimentacaoModel> get movimentacoesMesSelecionado => _movimentacoesMesSelecionado;

  @override
  List<MovimentacaoModel> get movimentacoesPorAba => _registrosAbaMovimentacao;

  @override
  Stream<Map<String, List<MovimentacaoModel>>> buscarDadosMovimentacao() {
    return Stream.multi((controller) {
      late final StreamSubscription<Map<String, List<MovimentacaoModel>>> subMovimentacoes;
      late final StreamSubscription<dynamic> subRecorrencias;

      void emitSnapshot() {
        controller.add(_mesclarComRecorrencias(_ultimoSnapshotMovimentacoes));
      }

      subMovimentacoes = _movimentacaoRepository.buscarDadosMovimentacao().listen(
        (event) {
          _ultimoSnapshotMovimentacoes = event;
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

    final List<String> orderedKeys = merged.keys.toList()..sort((a, b) => _parseMesAno(a).compareTo(_parseMesAno(b)));

    _todasMovimentacoes = {
      for (final String key in orderedKeys)
        key: (merged[key]!
          ..sort((a, b) {
            final int dateCompare = a.data.compareTo(b.data);
            if (dateCompare != 0) {
              return dateCompare;
            }
            return a.id.compareTo(b.id);
          })),
    };

    return _todasMovimentacoes;
  }

  @override
  List<MovimentacaoModel> filtrarMovimentacao(int posicao, TipoRegistroEnum tabSelecionada) {
    if (_todasMovimentacoes.isEmpty) {
      _movimentacoesMesSelecionado = [];
      _registrosAbaMovimentacao = [];
      return _movimentacoesMesSelecionado;
    }

    final int posicaoAjustada = posicao >= _todasMovimentacoes.length ? _todasMovimentacoes.length - 1 : posicao;
    final MapEntry<String, List<MovimentacaoModel>> entry = _todasMovimentacoes.entries.elementAt(posicaoAjustada);

    final DateTime mesSelecionado = _parseMesAno(entry.key);
    final List<MovimentacaoModel> sugestoes = _recorrenciaRepository.buscarSugestoesParaMes(mesSelecionado);

    _movimentacoesMesSelecionado =
        [
          ...entry.value,
          ...sugestoes.where((sugestao) => !_containsSugestao(entry.value, sugestao)),
        ]..sort((a, b) {
          final int dateCompare = a.data.compareTo(b.data);
          if (dateCompare != 0) {
            return dateCompare;
          }
          return a.id.compareTo(b.id);
        });

    filtrarMovimentacaoAba(tabSelecionada);

    return _movimentacoesMesSelecionado;
  }

  @override
  void filtrarMovimentacaoAba(TipoRegistroEnum tabSelecionada) {
    _registrosAbaMovimentacao = switch (tabSelecionada) {
      TipoRegistroEnum.todos => _movimentacoesMesSelecionado,
      TipoRegistroEnum.entrada =>
        _movimentacoesMesSelecionado
            .where((element) => element.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id)
            .toList(),
      TipoRegistroEnum.saida =>
        _movimentacoesMesSelecionado
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

  String _formatMesAno(DateTime date) => '${date.getFormattedMonth()}/${date.year}';

  DateTime _parseMesAno(String key) {
    final List<String> parts = key.split('/');
    if (parts.length != 2) {
      return DateTime.now();
    }

    final int year = int.tryParse(parts[1]) ?? DateTime.now().year;
    final int month = switch (parts[0]) {
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
      _ => DateTime.now().month,
    };

    return DateTime(year, month);
  }
}
