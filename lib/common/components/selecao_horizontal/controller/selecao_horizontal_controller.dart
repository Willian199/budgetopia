import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/config/update_interface.dart';
import 'package:budgetopia/common/components/selecao_horizontal/state/selecao_horizontal_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

final class SelecaoHorizontalController<ConfigT extends UpdateInterface> with DDIEventSender<SelecaoHorizontalState>, PreDestroy, PostConstruct {
  late final StreamSubscription<SelecaoHorizontalDados> _ref;

  void setDados(SelecaoHorizontalDados dados) {
    fire(SelecaoHorizontalState(itens: dados.$2, posicao: dados.$1));
  }

  void alterouPosicao(int posicao) {
    if (state != null) {
      fire(state!.copyWith(posicao: posicao));
    }
  }

  @override
  FutureOr<void> onPreDestroy() {
    _ref.cancel();
  }

  @override
  FutureOr<void> onPostConstruct() {
    _ref = ddi.get<ConfigT>().dados.listen(setDados);
  }
}
