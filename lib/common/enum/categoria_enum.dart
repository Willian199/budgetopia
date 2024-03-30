enum CategoriaEnum {
  Alimentacao(1, 'Alimentação'),
  Aluguel(2, 'Aluguel'),
  Entretenimento(3, 'Entretenimento'),
  Outros(4, 'Outros');

  const CategoriaEnum(this.id, this.nome);
  final String nome;
  final int id;

  static final Map<int, CategoriaEnum> _findById = Map.fromEntries(CategoriaEnum.values.map((value) => MapEntry(value.id, value)));

  static CategoriaEnum? getById(int value) => _findById[value];
}
