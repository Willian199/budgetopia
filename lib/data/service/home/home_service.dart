import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';

abstract class HomeService {
  Stream<Map<String, List<MovimentacaoModel>>> buscarDadosMovimentacao();

  List<MovimentacaoModel> filtrarMovimentacao(int posicao, TipoRegistroEnum tabSelecionada);

  List<MovimentacaoModel> get movimentacoesMesSelecionado;

  void filtrarMovimentacaoAba(TipoRegistroEnum tabSelecionada);

  List<MovimentacaoModel> get movimentacoesPorAba;
}
