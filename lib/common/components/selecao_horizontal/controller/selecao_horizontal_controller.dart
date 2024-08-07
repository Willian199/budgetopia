import 'package:budgetopia/common/components/selecao_horizontal/state/selecao_horizontal_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class SelecaoHorizontalController with DDIEventSender<SelecaoHorizontalState> {
  List<String> get itens => state?.itens ?? [];

  int get posicao => state?.posicao ?? 0;

  void setDados(int posicao, List<String> itens) {
    fire(SelecaoHorizontalState(itens: itens, posicao: posicao));
  }

  void alterouPosicao(int posicao) {
    if (state != null) {
      fire(state!.copyWith(posicao: posicao, itens: itens));
    }
  }
}
