import 'package:budgetopia/common/constantes/strings.dart';

enum TipoMovimentacaoEnum {
  entrada(Strings.ENTRADA, 1),
  saida(Strings.SAIDA, 2);

  const TipoMovimentacaoEnum(this.nome, this.id);
  final String nome;
  final int id;

  static final Map<int, TipoMovimentacaoEnum> _findById = Map.fromEntries(TipoMovimentacaoEnum.values.map((value) => MapEntry(value.id, value)));

  static TipoMovimentacaoEnum? getById(int value) => _findById[value];
}
