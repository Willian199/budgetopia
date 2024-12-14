import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/ui/movimentacao/controller/categoria_controller.dart';
import 'package:budgetopia/ui/movimentacao/controller/data_movimentacao_controller.dart';
import 'package:budgetopia/ui/movimentacao/controller/status_pagamento_controller.dart';
import 'package:budgetopia/ui/movimentacao/controller/tipo_movimentacao_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class MovimentacaoController {
  MovimentacaoController();

  late final DataMovimentacaoController _dataMovimentacaoController = ddi();
  late final CategoriaController _categoriaController = ddi();
  late final TipoMovimentacaoController _tipoMovimentacaoController = ddi();
  late final MovimentacaoRepository _movimentacaoRepository = ddi();
  late final StatusPagamentoController _statusPagamentoController = ddi();

  bool salvar({required String titulo, required double valor, required String observacao, required int id}) {
    final MovimentacaoEntity obj = MovimentacaoEntity(
      id: id,
      data: _dataMovimentacaoController.dataSelecionada,
      tipoMovimentacao: _tipoMovimentacaoController.tipoMovimentacaoSelecionada.id,
      codigoCategoria: _categoriaController.categoriaSelecionada.id,
      titulo: titulo,
      valor: valor,
      observacao: observacao,
      status: _statusPagamentoController.status,
    );

    return _movimentacaoRepository.salvar(obj) > 0;
  }

  bool remover(int id) => _movimentacaoRepository.remover(id);
}
