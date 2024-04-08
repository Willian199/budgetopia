import 'package:budgetopia/config/banco/entity/movimentacao_entity.dart';

class MovimentacaoModel {
  factory MovimentacaoModel.fromMovimentacaoEntity(MovimentacaoEntity entity) {
    return MovimentacaoModel(
      titulo: entity.titulo,
      valor: entity.valor,
      data: entity.data,
      codigoCategoria: entity.codigoCategoria,
      id: entity.id,
      tipoMovimentacao: entity.tipoMovimentacao,
      observacao: entity.observacao,
      status: entity.status,
    );
  }

  MovimentacaoModel({
    required this.id,
    required this.tipoMovimentacao,
    required this.titulo,
    required this.valor,
    required this.data,
    required this.codigoCategoria,
    this.observacao,
    this.status = false,
  });

  final String titulo;
  final double valor;
  final DateTime data;
  final int codigoCategoria;
  final int id;
  final int tipoMovimentacao;
  final String? observacao;
  final bool status;
}
