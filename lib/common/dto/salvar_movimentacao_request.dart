import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_cadastro_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_recorrencia_enum.dart';

final class SalvarMovimentacaoRequest {
  const SalvarMovimentacaoRequest({
    required this.formValido,
    required this.isEdicaoRecorrencia,
    required this.possuiMovimentacao,
    required this.id,
    required this.titulo,
    required this.valor,
    required this.observacao,
    required this.parcelas,
    required this.codigoRecorrencia,
    required this.recorrenciaId,
    required this.data,
    required this.dataFimRecorrencia,
    required this.categoria,
    required this.tipoMovimentacao,
    required this.status,
    required this.tipoCadastro,
    required this.tipoRecorrencia,
    required this.intervaloRecorrenciaDias,
    required this.recorrenciaSemDataFim,
  });

  final bool formValido;
  final bool isEdicaoRecorrencia;
  final bool possuiMovimentacao;
  final int id;
  final String titulo;
  final String valor;
  final String observacao;
  final String parcelas;
  final int codigoRecorrencia;
  final int recorrenciaId;
  final DateTime data;
  final DateTime dataFimRecorrencia;
  final CategoriaEnum categoria;
  final TipoMovimentacaoEnum tipoMovimentacao;
  final bool status;
  final TipoCadastroMovimentacaoEnum tipoCadastro;
  final TipoRecorrenciaEnum tipoRecorrencia;
  final int intervaloRecorrenciaDias;
  final bool recorrenciaSemDataFim;

  bool get isCadastroParcelado {
    return !isEdicaoRecorrencia && !possuiMovimentacao && tipoCadastro == TipoCadastroMovimentacaoEnum.parcelado;
  }

  bool get isCadastroRecorrencia {
    return isEdicaoRecorrencia || (!possuiMovimentacao && tipoCadastro == TipoCadastroMovimentacaoEnum.recorrencia);
  }
}
