enum CategoriaEnum {
  Alimentacao(1, 'Alimentacao', 'alimentacao.png'),
  Aluguel(2, 'Aluguel', 'aluguel.png'),
  Animais(3, 'Animais', 'animais.png'),
  Bebidas(4, 'Bebidas', 'bebidas.png'),
  Beleza(5, 'Beleza', 'beleza.png'),
  Caridade(6, 'Caridade', 'caridade.png'),
  Compras(7, 'Compras', 'compras.png'),
  Contas(8, 'Contas', 'contas.png'),
  CuidadosPessoais(9, 'Cuidados Pessoais', 'cuidados_pessoais.png'),
  Educacao(10, 'Educacao', 'educacao.png'),
  Eletronicos(11, 'Eletronicos', 'eletronicos.png'),
  Energia(12, 'Energia', 'energia.png'),
  Entretenimento(13, 'Entretenimento', 'entretenimento.png'),
  Esportes(14, 'Esportes', 'esportes.png'),
  Eventos(15, 'Eventos', 'eventos.png'),
  Festas(16, 'Festas', 'festas.png'),
  Filhos(17, 'Filhos', 'filhos.png'),
  Hobbies(18, 'Hobbies', 'hobbies.png'),
  Impostos(19, 'Impostos', 'impostos.png'),
  Imprevistos(20, 'Imprevistos', 'imprevistos.png'),
  Investimentos(21, 'Investimentos', 'investimentos.png'),
  Jogos(22, 'Jogos', 'jogos.png'),
  Lazer(23, 'Lazer', 'lazer.png'),
  Livros(24, 'Livros', 'livros.png'),
  Manutencao(25, 'Manutencao', 'manutencao.png'),
  Musica(26, 'Musica', 'musica.png'),
  Presentes(27, 'Presentes', 'presentes.png'),
  Roupas(28, 'Roupas', 'roupas.png'),
  Saude(29, 'Saude', 'saude.png'),
  Seguros(30, 'Seguros', 'seguros.png'),
  Tecnologia(31, 'Tecnologia', 'tecnologia.png'),
  Transporte(32, 'Transporte', 'transporte.png'),
  Viagem(33, 'Viagem', 'viagem.png'),
  Outros(99, 'Outros', 'outros.png');

  const CategoriaEnum(this.id, this.nome, this.icone);
  final String nome;
  final int id;
  final String icone;

  static final Map<int, CategoriaEnum> _findById = Map.fromEntries(CategoriaEnum.values.map((value) => MapEntry(value.id, value)));

  static CategoriaEnum? getById(int value) => _findById[value];
}
