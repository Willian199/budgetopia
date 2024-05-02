import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';
import 'package:budgetopia/config/banco/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/pages/movimentacao/controller/categoria_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/data_movimentacao_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/status_pagamento_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/tipo_movimentacao_controller.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class MovimentacaoController {
  MovimentacaoController()
      : _dataMovimentacaoController = ddi(),
        _categoriaController = ddi(),
        _tipoMovimentacaoController = ddi(),
        _statusPagamentoController = ddi(),
        _movimentacaoRepository = ddi();

  final DataMovimentacaoController _dataMovimentacaoController;
  final CategoriaController _categoriaController;
  final TipoMovimentacaoController _tipoMovimentacaoController;
  final MovimentacaoRepository _movimentacaoRepository;
  final StatusPagamentoController _statusPagamentoController;

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
