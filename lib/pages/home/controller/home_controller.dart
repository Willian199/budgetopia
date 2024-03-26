import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/pages/home/model/home_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeController with DDIEventSender<HomeState> {
  Set<TipoRegistroEnum> _tabSelecionada = {TipoRegistroEnum.todos};

  void changeTabSelecionada(Set<TipoRegistroEnum> value) {
    _tabSelecionada = value;
    fire(HomeState(tabSelecionada: _tabSelecionada));
  }
}
