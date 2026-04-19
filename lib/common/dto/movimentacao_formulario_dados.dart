import 'package:budgetopia/common/constantes/strings.dart';

final class MovimentacaoFormularioDados {
  const MovimentacaoFormularioDados({
    this.titulo = '',
    this.valor = '',
    this.observacao = '',
    this.parcelas = Strings.QUANTIDADE_PARCELAS_PADRAO,
    this.intervaloRecorrencia = Strings.INTERVALO_RECORRENCIA_PADRAO,
  });

  final String titulo;
  final String valor;
  final String observacao;
  final String parcelas;
  final String intervaloRecorrencia;
}
