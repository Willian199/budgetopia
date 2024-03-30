import 'dart:async';

import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/pages/home/controller/time_line_opacity_controller.dart';
import 'package:budgetopia/pages/home/state/home_state.dart';
import 'package:budgetopia/pages/movimentacao/controller/lista_movimentacao_controller.dart';
import 'package:budgetopia/pages/movimentacao/model/movimentacao_model.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeController with DDIEventSender<HomeState>, PostConstruct {
  HomeController({
    required ListaMovimentacaoController listaMovimentacaoController,
    required TimeLineOpacityController timeLineOpacityController,
  })  : _listaMovimentacaoController = listaMovimentacaoController,
        _timeLineOpacityController = timeLineOpacityController;

  final ListaMovimentacaoController _listaMovimentacaoController;
  final TimeLineOpacityController _timeLineOpacityController;

  late List<MovimentacaoModel> _registrosMovimentacao;

  List<MovimentacaoModel> get registrosMovimentacao => _registrosMovimentacao;

  void refresh(Set<TipoRegistroEnum> value) {
    _registrosMovimentacao = _listaMovimentacaoController.filter(value.first);
    _timeLineOpacityController.changePosition(0);
    fire(HomeState(value));
  }

  @override
  FutureOr<void> onPostConstruct() {
    _registrosMovimentacao = _listaMovimentacaoController.filter(TipoRegistroEnum.todos);
  }
}
