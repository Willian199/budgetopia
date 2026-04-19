final class MovimentacaoFormularioDados {
  const MovimentacaoFormularioDados({
    this.titulo = '',
    this.valor = '',
    this.observacao = '',
    this.parcelas = '2',
    this.intervaloRecorrencia = '30',
  });

  final String titulo;
  final String valor;
  final String observacao;
  final String parcelas;
  final String intervaloRecorrencia;
}
