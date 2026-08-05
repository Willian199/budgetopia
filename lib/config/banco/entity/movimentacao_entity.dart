import 'package:objectbox/objectbox.dart';

@Entity()
class MovimentacaoEntity {
  MovimentacaoEntity({
    required this.titulo,
    required this.data,
    required this.tipoMovimentacao,
    required this.codigoCategoria,
    this.id = 0,
    this.valor = 0,
    this.observacao = '',
    this.status = false,
    this.codigoRecorrencia = 0,
  });
  @Id()
  int id;

  String titulo;
  double valor;

  @Property(type: PropertyType.date)
  DateTime data;

  int codigoCategoria;

  int tipoMovimentacao;

  String observacao;

  bool status;

  int codigoRecorrencia;
}
