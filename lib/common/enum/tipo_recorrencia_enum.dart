enum TipoRecorrenciaEnum {
  diaria('Diaria', 1, 1),
  semanal('Semanal', 2, 7),
  quinzenal('Quinzenal', 3, 15),
  mensal('Mensal', 4, 0),
  intervaloDias('Dias Fixos', 5, 0);

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
