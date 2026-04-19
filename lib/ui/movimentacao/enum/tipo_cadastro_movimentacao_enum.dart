import 'package:budgetopia/common/constantes/strings.dart';

enum TipoCadastroMovimentacaoEnum {
  unico(Strings.CADASTRO_UNICO),
  parcelado(Strings.CADASTRO_PARCELADO),
  recorrencia(Strings.CADASTRO_RECORRENCIA)
  ;

  const TipoCadastroMovimentacaoEnum(this.nome);
  final String nome;
}
