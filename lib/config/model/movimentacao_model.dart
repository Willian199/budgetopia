// ignore_for_file: public_member_api_docs, sort_constructors_first
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
      codigoRecorrencia: entity.codigoRecorrencia,
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
    this.sugestao = false,
    this.codigoRecorrencia = 0,
  });

  final String titulo;
  final double valor;
  final DateTime data;
  final int codigoCategoria;
  final int id;
  final int tipoMovimentacao;
  final String? observacao;
  final bool status;
  final bool sugestao;
  final int codigoRecorrencia;

  @override
  bool operator ==(covariant MovimentacaoModel other) {
    if (identical(this, other)) {
      return true;
    }

    return other.titulo == titulo &&
        other.valor == valor &&
        other.data == data &&
        other.codigoCategoria == codigoCategoria &&
        other.id == id &&
        other.tipoMovimentacao == tipoMovimentacao &&
        other.observacao == observacao &&
        other.status == status &&
        other.sugestao == sugestao &&
        other.codigoRecorrencia == codigoRecorrencia;
  }

  @override
  int get hashCode {
    return titulo.hashCode ^
        valor.hashCode ^
        data.hashCode ^
        codigoCategoria.hashCode ^
        id.hashCode ^
        tipoMovimentacao.hashCode ^
        observacao.hashCode ^
        status.hashCode ^
        sugestao.hashCode ^
        codigoRecorrencia.hashCode;
  }
}
