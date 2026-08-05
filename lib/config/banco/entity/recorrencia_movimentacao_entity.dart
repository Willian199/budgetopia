import 'package:objectbox/objectbox.dart';

@Entity()
class RecorrenciaMovimentacaoEntity {
  RecorrenciaMovimentacaoEntity({
    required this.titulo,
    required this.dataInicio,
    required this.dataFim,
    required this.tipoMovimentacao,
    required this.codigoCategoria,
    required this.tipoRecorrencia,
    this.id = 0,
    this.valorBase = 0,
    this.observacao = '',
    this.statusPadrao = false,
    this.intervaloDias = 0,
    this.ativo = true,
  });

  @Id()
  int id;

  String titulo;

  double valorBase;

  @Property(type: PropertyType.date)
  DateTime dataInicio;

  @Property(type: PropertyType.date)
  DateTime dataFim;

  int codigoCategoria;

  int tipoMovimentacao;

  int tipoRecorrencia;

  int intervaloDias;

  String observacao;

  bool statusPadrao;

  bool ativo;
}
