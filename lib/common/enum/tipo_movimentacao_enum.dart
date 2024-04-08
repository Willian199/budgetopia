import 'package:budgetopia/common/constantes/strings.dart';

enum TipoMovimentacaoEnum {
  entrada(Strings.ENTRADA, 1, 'money.png'),
  saida(Strings.SAIDA, 2, 'lost.png');

  const TipoMovimentacaoEnum(this.nome, this.id, this.icone);
  final String nome;
  final int id;
  final String icone;

  static final Map<int, TipoMovimentacaoEnum> _findById = Map.fromEntries(TipoMovimentacaoEnum.values.map((value) => MapEntry(value.id, value)));

  static TipoMovimentacaoEnum? getById(int value) => _findById[value];
}
