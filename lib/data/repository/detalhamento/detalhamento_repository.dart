import 'package:budgetopia/ui/home/model/grafico_model.dart';

typedef GraficoDetalhamento = ({List<GraficoModel> saidas, List<GraficoModel> entradas, List<GraficoModel> saldo});

typedef ResumoDetalhamento = ({double totalEntrada, double totalSaida, double totalSaldo});

typedef DetalhamentoDados = ({
  GraficoDetalhamento grafico,
  ResumoDetalhamento resumo,
  double valorSaldoObjetivo,
});

abstract interface class DetalhamentoRepository {
  Stream<DetalhamentoDados> buscarDados();
}
