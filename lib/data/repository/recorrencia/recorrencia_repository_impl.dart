import 'dart:math';

import 'package:budgetopia/common/enum/tipo_recorrencia_enum.dart';
import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/entity/recorrencia_movimentacao_entity.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/repository/recorrencia/recorrencia_repository.dart';
import 'package:budgetopia/data/service/recorrencia/recorrencia_service.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class RecorrenciaRepositoryImpl implements RecorrenciaRepository {
  late final RecorrenciaService _service = ddi();

  @override
  Stream<List<RecorrenciaMovimentacaoEntity>> buscarRecorrencias() => _service.buscarRecorrencias();

  @override
  int salvar(RecorrenciaMovimentacaoEntity recorrenciaEntity) => _service.salvar(recorrenciaEntity);

  @override
  bool remover(int id) => _service.remover(id);

  @override
  RecorrenciaMovimentacaoEntity? buscarPorId(int id) => _service.buscarPorId(id);

  @override
  List<DateTime> buscarMesesComSugestoes({
    required DateTime inicio,
    required DateTime fim,
  }) {
    final DateTime primeiroMes = DateTime(inicio.year, inicio.month);
    final DateTime ultimoMes = DateTime(fim.year, fim.month);
    final List<DateTime> meses = [];
    DateTime cursor = primeiroMes;

    while (!cursor.isAfter(ultimoMes)) {
      if (buscarSugestoesParaMes(cursor).isNotEmpty) {
        meses.add(cursor);
      }
      cursor = DateTime(cursor.year, cursor.month + 1);
    }

    return meses;
  }

  @override
  List<MovimentacaoModel> buscarSugestoesParaMes(DateTime mesReferencia) {
    final DateTime inicioMes = DateTime(mesReferencia.year, mesReferencia.month);
    final DateTime fimMes = DateTime(
      mesReferencia.year,
      mesReferencia.month + 1,
      0,
      23,
      59,
      59,
      999,
      999,
    );

    final List<MovimentacaoModel> sugestoes = [];

    for (final RecorrenciaMovimentacaoEntity recorrencia in _service.listarRecorrenciasAtivas()) {
      final List<DateTime> datas = _gerarDatasRecorrenciaNoPeriodo(recorrencia, inicioMes, fimMes);

      for (final DateTime data in datas) {
        if (_service.existeMovimentacaoConfirmada(recorrenciaId: recorrencia.id, data: data)) {
          continue;
        }

        final double valorSugerido = _calcularMediaUltimosValores(
          recorrenciaId: recorrencia.id,
          ateData: data,
          fallback: recorrencia.valorBase,
        );

        sugestoes.add(
          MovimentacaoModel(
            id: _gerarIdSugestao(recorrenciaId: recorrencia.id, data: data),
            tipoMovimentacao: recorrencia.tipoMovimentacao,
            titulo: recorrencia.titulo,
            valor: valorSugerido,
            data: data,
            codigoCategoria: recorrencia.codigoCategoria,
            observacao: recorrencia.observacao,
            status: recorrencia.statusPadrao,
            sugestao: true,
            codigoRecorrencia: recorrencia.id,
          ),
        );
      }
    }

    sugestoes.sort((a, b) {
      final int dataCompare = a.data.compareTo(b.data);
      if (dataCompare != 0) {
        return dataCompare;
      }
      return a.titulo.compareTo(b.titulo);
    });

    return sugestoes;
  }

  @override
  bool existeMovimentacaoConfirmada({
    required int recorrenciaId,
    required DateTime data,
  }) {
    return _service.existeMovimentacaoConfirmada(recorrenciaId: recorrenciaId, data: data);
  }

  double _calcularMediaUltimosValores({
    required int recorrenciaId,
    required DateTime ateData,
    required double fallback,
  }) {
    final DateTime limiteData = ateData.subtract(const Duration(microseconds: 1));
    final List<MovimentacaoEntity> historico = _service.buscarMovimentacoesPorRecorrencia(
      recorrenciaId: recorrenciaId,
      ateData: limiteData,
    );

    if (historico.isEmpty) {
      return fallback;
    }

    final double soma = historico.fold(0, (total, item) => total + item.valor);
    return soma / historico.length;
  }

  int _gerarIdSugestao({
    required int recorrenciaId,
    required DateTime data,
  }) {
    final int yyyymmdd = (data.year * 10000) + (data.month * 100) + data.day;
    return -((recorrenciaId * 100000000) + yyyymmdd);
  }

  List<DateTime> _gerarDatasRecorrenciaNoPeriodo(
    RecorrenciaMovimentacaoEntity recorrencia,
    DateTime inicioPeriodo,
    DateTime fimPeriodo,
  ) {
    final TipoRecorrenciaEnum tipo =
        TipoRecorrenciaEnum.getById(recorrencia.tipoRecorrencia) ?? TipoRecorrenciaEnum.mensal;

    if (tipo == TipoRecorrenciaEnum.mensal) {
      final DateTime dataMensal = _ajustarDiaNoMes(recorrencia.dataInicio, inicioPeriodo.year, inicioPeriodo.month);
      final DateTime dataFimRecorrencia = _resolveDataFim(recorrencia);
      if (dataMensal.isBefore(recorrencia.dataInicio)) {
        return const [];
      }
      if (dataMensal.isBefore(inicioPeriodo) ||
          dataMensal.isAfter(fimPeriodo) ||
          dataMensal.isAfter(dataFimRecorrencia)) {
        return const [];
      }
      return [dataMensal];
    }

    final int intervaloDias = tipo == TipoRecorrenciaEnum.intervaloDias
        ? recorrencia.intervaloDias
        : max(1, tipo.intervaloPadraoDias);

    final DateTime dataFimRecorrencia = _resolveDataFim(recorrencia);

    if (intervaloDias <= 0 ||
        recorrencia.dataInicio.isAfter(fimPeriodo) ||
        recorrencia.dataInicio.isAfter(dataFimRecorrencia)) {
      return const [];
    }

    DateTime primeiro = recorrencia.dataInicio;
    if (primeiro.isBefore(inicioPeriodo)) {
      final int diff = inicioPeriodo.difference(primeiro).inDays;
      final int saltos = (diff / intervaloDias).ceil();
      primeiro = primeiro.add(Duration(days: saltos * intervaloDias));
    }

    final List<DateTime> datas = [];
    DateTime cursor = primeiro;
    while (!cursor.isAfter(fimPeriodo) && !cursor.isAfter(dataFimRecorrencia)) {
      if (!cursor.isBefore(inicioPeriodo) && !cursor.isBefore(recorrencia.dataInicio)) {
        datas.add(cursor);
      }
      cursor = cursor.add(Duration(days: intervaloDias));
    }

    return datas;
  }

  DateTime _resolveDataFim(RecorrenciaMovimentacaoEntity recorrencia) {
    if (recorrencia.dataFim.year < 2000) {
      return DateTime(2100, 12, 31, 23, 59, 59);
    }
    return recorrencia.dataFim;
  }

  DateTime _ajustarDiaNoMes(DateTime base, int year, int month) {
    final int lastDay = DateTime(year, month + 1, 0).day;
    final int day = base.day > lastDay ? lastDay : base.day;
    return DateTime(
      year,
      month,
      day,
      base.hour,
      base.minute,
      base.second,
      base.millisecond,
      base.microsecond,
    );
  }
}
