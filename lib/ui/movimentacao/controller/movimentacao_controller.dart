import 'dart:async';

import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_recorrencia_enum.dart';
import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/entity/recorrencia_movimentacao_entity.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/data/repository/recorrencia/recorrencia_repository.dart';
import 'package:budgetopia/ui/movimentacao/enum/tipo_cadastro_movimentacao_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

/// Case do módulo de movimentação: armazena o estado do formulário em [ValueNotifier]s
/// e executa salvar/remover via repositório. O controller é apenas ponta de acesso ao listener.
final class MovimentacaoController with PreDestroy {
  MovimentacaoController()
    : data = ValueNotifier(DateTime.now()),
      dataFimRecorrencia = ValueNotifier(DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day)),
      categoria = ValueNotifier(CategoriaEnum.Alimentacao),
      tipoMovimentacao = ValueNotifier(TipoMovimentacaoEnum.entrada),
      status = ValueNotifier(false),
      tipoCadastro = ValueNotifier(TipoCadastroMovimentacaoEnum.unico),
      quantidadeParcelas = ValueNotifier(2),
      tipoRecorrencia = ValueNotifier(TipoRecorrenciaEnum.mensal),
      intervaloRecorrenciaDias = ValueNotifier(30);

  /// Data da movimentação (reativo).
  final ValueNotifier<DateTime> data;

  /// Data máxima para geração das sugestões da recorrência.
  final ValueNotifier<DateTime> dataFimRecorrencia;

  /// Categoria selecionada (reativo).
  final ValueNotifier<CategoriaEnum> categoria;

  /// Tipo de movimentação (reativo).
  final ValueNotifier<TipoMovimentacaoEnum> tipoMovimentacao;

  /// Status de pagamento realizado (reativo).
  final ValueNotifier<bool> status;

  /// Tipo de cadastro (unico ou parcelado).
  final ValueNotifier<TipoCadastroMovimentacaoEnum> tipoCadastro;

  /// Quantidade de parcelas quando o cadastro for parcelado.
  final ValueNotifier<int> quantidadeParcelas;

  /// Tipo da recorrencia selecionada.
  final ValueNotifier<TipoRecorrenciaEnum> tipoRecorrencia;

  /// Intervalo para recorrencia por dias fixos.
  final ValueNotifier<int> intervaloRecorrenciaDias;

  late final MovimentacaoRepository _repository = ddi();
  late final RecorrenciaRepository _recorrenciaRepository = ddi();
  bool _recorrenciaSemDataFim = false;

  bool get recorrenciaSemDataFim => _recorrenciaSemDataFim;

  void alterarData(DateTime value) {
    data.value = value;
    if (dataFimRecorrencia.value.isBefore(value)) {
      dataFimRecorrencia.value = value;
    }
  }

  void alterarDataFimRecorrencia(DateTime value) {
    dataFimRecorrencia.value = value.isBefore(data.value) ? data.value : value;
  }

  void definirRecorrenciaSemDataFim(bool value) {
    _recorrenciaSemDataFim = value;
  }

  void selecionarCategoria(CategoriaEnum? value) {
    if (value != null) {
      categoria.value = value;
    }
  }

  void selecionarTipoMovimentacao(TipoMovimentacaoEnum? value) {
    if (value != null) {
      tipoMovimentacao.value = value;
    }
  }

  void alterarStatus(bool value) {
    status.value = value;
  }

  void alterarTipoCadastro(TipoCadastroMovimentacaoEnum value) {
    tipoCadastro.value = value;
    if (value != TipoCadastroMovimentacaoEnum.recorrencia) {
      _recorrenciaSemDataFim = false;
    }
  }

  void alterarQuantidadeParcelas(int value) {
    quantidadeParcelas.value = value <= 0 ? 1 : value;
  }

  void alterarTipoRecorrencia(TipoRecorrenciaEnum? value) {
    if (value != null) {
      tipoRecorrencia.value = value;
    }
  }

  void alterarIntervaloRecorrenciaDias(int value) {
    intervaloRecorrenciaDias.value = value <= 0 ? 1 : value;
  }

  RecorrenciaMovimentacaoEntity? buscarRecorrenciaPorId(int id) {
    if (id <= 0) {
      return null;
    }
    return _recorrenciaRepository.buscarPorId(id);
  }

  /// Persiste a movimentação; campos de texto vêm da View.
  bool salvar({
    required int id,
    required String titulo,
    required double valor,
    required String observacao,
    int parcelas = 1,
    int codigoRecorrencia = 0,
    int recorrenciaId = 0,
  }) {
    if (tipoCadastro.value == TipoCadastroMovimentacaoEnum.parcelado && id == 0) {
      return _salvarParcelado(
        titulo: titulo,
        valor: valor,
        observacao: observacao,
        parcelas: parcelas,
      );
    }

    if (tipoCadastro.value == TipoCadastroMovimentacaoEnum.recorrencia && id == 0) {
      return _salvarRecorrencia(
        titulo: titulo,
        valor: valor,
        observacao: observacao,
        recorrenciaId: recorrenciaId,
      );
    }

    final entity = MovimentacaoEntity(
      id: id,
      titulo: titulo,
      valor: valor,
      observacao: observacao,
      data: data.value,
      codigoCategoria: categoria.value.id,
      tipoMovimentacao: tipoMovimentacao.value.id,
      status: status.value,
      codigoRecorrencia: codigoRecorrencia,
    );
    return _repository.salvar(entity) > 0;
  }

  bool _salvarParcelado({
    required String titulo,
    required double valor,
    required String observacao,
    required int parcelas,
  }) {
    if (parcelas <= 1) {
      return false;
    }

    final List<MovimentacaoEntity> entidades = <MovimentacaoEntity>[];
    for (int indice = 0; indice < parcelas; indice++) {
      entidades.add(
        MovimentacaoEntity(
        titulo: titulo,
        valor: valor,
        observacao: observacao,
        data: _addMonths(data.value, indice),
        codigoCategoria: categoria.value.id,
        tipoMovimentacao: tipoMovimentacao.value.id,
        status: status.value,
      ),
      );
    }

    final List<int> ids = _repository.salvarTodos(entidades);
    if (ids.length != parcelas) {
      return false;
    }
    return ids.every((id) => id > 0);
  }

  bool _salvarRecorrencia({
    required String titulo,
    required double valor,
    required String observacao,
    required int recorrenciaId,
  }) {
    if (tipoRecorrencia.value.usaIntervaloDias && intervaloRecorrenciaDias.value <= 0) {
      return false;
    }

    final RecorrenciaMovimentacaoEntity entity = RecorrenciaMovimentacaoEntity(
      id: recorrenciaId,
      titulo: titulo,
      valorBase: valor,
      observacao: observacao,
      dataInicio: data.value,
      dataFim: _recorrenciaSemDataFim ? DateTime(1) : dataFimRecorrencia.value,
      codigoCategoria: categoria.value.id,
      tipoMovimentacao: tipoMovimentacao.value.id,
      tipoRecorrencia: tipoRecorrencia.value.id,
      intervaloDias: tipoRecorrencia.value.usaIntervaloDias ? intervaloRecorrenciaDias.value : 0,
      statusPadrao: status.value,
    );

    return _recorrenciaRepository.salvar(entity) > 0;
  }

  DateTime _addMonths(DateTime baseDate, int monthsToAdd) {
    final int monthIndex = baseDate.month - 1 + monthsToAdd;
    final int year = baseDate.year + (monthIndex ~/ 12);
    final int month = monthIndex % 12 + 1;
    final int lastDayOfTargetMonth = DateTime(year, month + 1, 0).day;
    final int day = baseDate.day > lastDayOfTargetMonth ? lastDayOfTargetMonth : baseDate.day;
    return DateTime(
      year,
      month,
      day,
      baseDate.hour,
      baseDate.minute,
      baseDate.second,
      baseDate.millisecond,
      baseDate.microsecond,
    );
  }

  bool remover(int id) => _repository.remover(id);

  /// Libera os notifiers ao encerrar o fluxo.
  void dispose() {
    data.dispose();
    dataFimRecorrencia.dispose();
    categoria.dispose();
    tipoMovimentacao.dispose();
    status.dispose();
    tipoCadastro.dispose();
    quantidadeParcelas.dispose();
    tipoRecorrencia.dispose();
    intervaloRecorrenciaDias.dispose();
  }

  @override
  FutureOr<void> onPreDestroy() {
    dispose();
  }
}
