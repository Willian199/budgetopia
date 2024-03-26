class MovimentacaoModel {
  MovimentacaoModel({required this.id, required this.isIncome, required this.titulo, required this.valor, required this.data, this.categoria});

  final String titulo;
  final num valor;
  final DateTime data;
  final String? categoria;
  final int id;
  final bool isIncome;

  static final List<MovimentacaoModel> movimentacoes = [
    MovimentacaoModel(id: 1, isIncome: true, titulo: 'Salário', valor: 7400.00, data: DateTime.now()),
    MovimentacaoModel(id: 2, isIncome: false, titulo: 'Conta de Água', valor: 50.00, data: DateTime.now(), categoria: 'Moradia'),
    MovimentacaoModel(id: 3, isIncome: false, titulo: 'Conta de Luz', valor: 110.00, data: DateTime.now(), categoria: 'Moradia'),
    MovimentacaoModel(id: 4, isIncome: false, titulo: 'Conta de Internet', valor: 120.00, data: DateTime.now(), categoria: 'Moradia'),
    MovimentacaoModel(id: 4, isIncome: false, titulo: 'Cartão de Credito Inter', valor: 1000.00, data: DateTime.now(), categoria: 'Cartão'),
    MovimentacaoModel(id: 5, isIncome: false, titulo: 'Cartão de Credito Nubank', valor: 1000.00, data: DateTime.now(), categoria: 'Cartão'),
  ];
}
