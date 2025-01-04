import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/config/update_interface.dart';
import 'package:budgetopia/common/components/selecao_horizontal/state/selecao_horizontal_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class SelecaoHorizontalController<ConfigT extends UpdateInterface> with DDIEventSender<SelecaoHorizontalState>, PreDestroy, PostConstruct {
  late final StreamSubscription<EstruturaEvento> _refDados;
  late final StreamSubscription<int> _refPosicao;
  late final UpdateInterface _updateInterface = ddi.get<ConfigT>();

  void alterouItens(EstruturaEvento evento) {
    final (int posicao, List<String> itens) = evento;

    fire(state?.copyWith(itens: itens, posicao: posicao) ?? SelecaoHorizontalState(posicao: posicao, itens: itens));
  }

  void alterouPosicao(int posicao) {
    fire(state?.copyWith(posicao: posicao) ?? SelecaoHorizontalState(posicao: posicao, itens: []));
  }

  @override
  FutureOr<void> onPreDestroy() {
    _refDados.cancel();
    _refPosicao.cancel();
  }

  @override
  FutureOr<void> onPostConstruct() {
    _refDados = _updateInterface.dados.listen(alterouItens);
    _refPosicao = _updateInterface.slidePosition.listen(alterouPosicao);
  }

  void updatePosition(int value) {
    _updateInterface.updatePosition(value);
  }
}
