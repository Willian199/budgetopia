import 'package:budgetopia/common/constantes/strings.dart';

enum TipoRecorrenciaEnum {
  diaria(Strings.RECORRENCIA_DIARIA, 1, 1),
  semanal(Strings.RECORRENCIA_SEMANAL, 2, 7),
  quinzenal(Strings.RECORRENCIA_QUINZENAL, 3, 15),
  mensal(Strings.RECORRENCIA_MENSAL, 4, 0),
  intervaloDias(Strings.RECORRENCIA_DIAS_FIXOS, 5, 0)
  ;

  const TipoRecorrenciaEnum(this.nome, this.id, this.intervaloPadraoDias);
  final String nome;
  final int id;
  final int intervaloPadraoDias;

  bool get usaIntervaloDias => this == TipoRecorrenciaEnum.intervaloDias;

  static final Map<int, TipoRecorrenciaEnum> _findById = Map.fromEntries(
    TipoRecorrenciaEnum.values.map((value) => MapEntry(value.id, value)),
  );

  static TipoRecorrenciaEnum? getById(int value) => _findById[value];
}
