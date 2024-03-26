import 'package:budgetopia/common/constantes/strings.dart';

enum TipoRegistroEnum {
  todos(Strings.TODOS, 0),
  entrada(Strings.ENTRADA, 1),
  saida(Strings.SAIDA, 2);

  const TipoRegistroEnum(this.nome, this.posicao);
  final String nome;
  final int posicao;

  static final Map<String, TipoRegistroEnum> _findByNome = Map.fromEntries(TipoRegistroEnum.values.map((value) => MapEntry(value.nome, value)));

  static final Map<int, TipoRegistroEnum> _findByPosicao = Map.fromEntries(TipoRegistroEnum.values.map((value) => MapEntry(value.posicao, value)));

  static TipoRegistroEnum? forValue(String value) => _findByNome[value];

  static TipoRegistroEnum? forIndex(int value) => _findByPosicao[value];
}
