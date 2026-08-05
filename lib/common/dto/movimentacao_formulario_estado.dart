import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_cadastro_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_recorrencia_enum.dart';

final class MovimentacaoFormularioEstado {
  const MovimentacaoFormularioEstado({
    this.data,
    this.dataFimRecorrencia,
    this.recorrenciaSemDataFim,
    this.categoria,
    this.tipoMovimentacao,
    this.status,
    this.tipoCadastro,
    this.quantidadeParcelas,
    this.tipoRecorrencia,
    this.intervaloRecorrenciaDias,
  });

  final DateTime? data;
  final DateTime? dataFimRecorrencia;
  final bool? recorrenciaSemDataFim;
  final CategoriaEnum? categoria;
  final TipoMovimentacaoEnum? tipoMovimentacao;
  final bool? status;
  final TipoCadastroMovimentacaoEnum? tipoCadastro;
  final int? quantidadeParcelas;
  final TipoRecorrenciaEnum? tipoRecorrencia;
  final int? intervaloRecorrenciaDias;
}
