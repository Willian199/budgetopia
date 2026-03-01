import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/data/repository/movimentacao/movimentacao_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

/// Case do módulo de movimentação: armazena o estado do formulário em [ValueNotifier]s
/// e executa salvar/remover via repositório. O controller é apenas ponta de acesso ao listener.
final class MovimentacaoController {
  MovimentacaoController()
    : data = ValueNotifier(DateTime.now()),
      categoria = ValueNotifier(CategoriaEnum.Alimentacao),
      tipoMovimentacao = ValueNotifier(TipoMovimentacaoEnum.entrada),
      status = ValueNotifier(false);

  /// Data da movimentação (reativo).
  final ValueNotifier<DateTime> data;

  /// Categoria selecionada (reativo).
  final ValueNotifier<CategoriaEnum> categoria;

  /// Tipo de movimentação (reativo).
  final ValueNotifier<TipoMovimentacaoEnum> tipoMovimentacao;

  /// Status de pagamento realizado (reativo).
  final ValueNotifier<bool> status;

  late final MovimentacaoRepository _repository = ddi();

  /// Abre o date picker e atualiza [data] ao selecionar.
  Future<bool> selecionarDataMovimentacao() async {
    final DateTime start = DateTime(2024);
    final DateTime? picked = await showDatePicker(
      context: ddi.get<GlobalKey<NavigatorState>>().currentContext!,
      initialDate: data.value,
      firstDate: start,
      lastDate: DateTime(2040),
      keyboardType: TextInputType.datetime,
    );

    if (picked != null && picked != data.value) {
      data.value = picked.isBefore(start) ? start : picked;
      return true;
    }

    return false;
  }

  void alterarData(DateTime value) {
    data.value = value;
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

  /// Persiste a movimentação; campos de texto vêm da View.
  bool salvar({
    required int id,
    required String titulo,
    required double valor,
    required String observacao,
  }) {
    final entity = MovimentacaoEntity(
      id: id,
      titulo: titulo,
      valor: valor,
      observacao: observacao,
      data: data.value,
      codigoCategoria: categoria.value.id,
      tipoMovimentacao: tipoMovimentacao.value.id,
      status: status.value,
    );
    return _repository.salvar(entity) > 0;
  }

  bool remover(int id) => _repository.remover(id);

  /// Libera os notifiers ao encerrar o fluxo.
  void dispose() {
    data.dispose();
    categoria.dispose();
    tipoMovimentacao.dispose();
    status.dispose();
  }
}
