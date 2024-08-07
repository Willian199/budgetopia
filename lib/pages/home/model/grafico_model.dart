class GraficoModel {
  GraficoModel({required this.index, required this.legenda, required this.valor});

  final double index;
  final double valor;
  final String legenda;

  static final List<GraficoModel> values = <GraficoModel>[
    GraficoModel(index: 0, valor: 0, legenda: ''),
    GraficoModel(index: 1, valor: 0, legenda: ''),
    GraficoModel(index: 2, valor: 1000.0, legenda: 'JAN'),
    GraficoModel(index: 3, valor: 900.0, legenda: 'FEV'),
    GraficoModel(index: 4, valor: 1200.0, legenda: 'MAR'),
    GraficoModel(index: 5, valor: 10000.0, legenda: 'ABR'),
    GraficoModel(index: 6, valor: 4000.0, legenda: 'MAI'),
    GraficoModel(index: 7, valor: 2000.0, legenda: 'JUN'),
    GraficoModel(index: 8, valor: 6000.0, legenda: 'JUL'),
    GraficoModel(index: 9, valor: 8000.0, legenda: 'AGO'),
    GraficoModel(index: 10, valor: 1000.0, legenda: 'SET'),
    GraficoModel(index: 11, valor: 1250.0, legenda: 'OUT'),
    GraficoModel(index: 12, valor: 10000.0, legenda: 'NOV'),
    GraficoModel(index: 13, valor: 6250.0, legenda: 'DEZ'),
    GraficoModel(index: 14, valor: 0, legenda: ''),
  ];
}
