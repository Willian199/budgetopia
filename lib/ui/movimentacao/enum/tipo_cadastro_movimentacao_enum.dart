enum TipoCadastroMovimentacaoEnum {
  unico('Unico'),
  parcelado('Parcelado'),
  recorrencia('Recorrencia');

  const TipoCadastroMovimentacaoEnum(this.nome);
  final String nome;
}
