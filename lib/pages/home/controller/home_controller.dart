import 'dart:async';

import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/pages/home/controller/time_line_opacity_controller.dart';
import 'package:budgetopia/pages/home/state/home_state.dart';
import 'package:budgetopia/pages/movimentacao/controller/lista_movimentacao_controller.dart';
import 'package:budgetopia/pages/movimentacao/model/movimentacao_model.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeController with DDIEventSender<HomeState>, PostConstruct {
  HomeController()
      : _listaMovimentacaoController = ddi(),
        _timeLineOpacityController = ddi();

  final ListaMovimentacaoController _listaMovimentacaoController;
  final TimeLineOpacityController _timeLineOpacityController;

  List<MovimentacaoModel> _todasMovimentacoes = [];

  late List<MovimentacaoModel> _registrosAbaMovimentacao;

  List<MovimentacaoModel> get registrosAbaMovimentacao => _registrosAbaMovimentacao;

  TipoRegistroEnum _tabSelecionada = TipoRegistroEnum.todos;
  TipoRegistroEnum get tabSelecionada => _tabSelecionada;

  HomeState _lastState = HomeState(tabSelecionada: {TipoRegistroEnum.todos}, valorEntrada: 0, valorSaida: 0, valorSaldo: 0);

  void refresh(Set<TipoRegistroEnum> value) {
    _tabSelecionada = value.first;
    _filtrarMovimentacaoes();
    fire(_lastState.copyWith(tabSelecionada: {_tabSelecionada}));
  }

  @override
  FutureOr<void> onPostConstruct() {
    _listaMovimentacaoController.filter().listen((List<MovimentacaoModel> event) {
      _todasMovimentacoes = event;

      _filtrarMovimentacaoes();

      double entrada = 0;
      double saida = 0;
      for (final MovimentacaoModel item in _todasMovimentacoes) {
        if (item.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id) {
          entrada += item.valor;
        } else {
          saida += item.valor;
        }
      }
      _timeLineOpacityController.changePosition(0);
      _lastState = HomeState(
        tabSelecionada: {_tabSelecionada},
        valorEntrada: entrada,
        valorSaida: saida,
        valorSaldo: entrada - saida,
      );

      fire(_lastState);
    });
  }

  void _filtrarMovimentacaoes() {
    _registrosAbaMovimentacao = switch (_tabSelecionada) {
      TipoRegistroEnum.todos => _todasMovimentacoes,
      TipoRegistroEnum.entrada => _todasMovimentacoes.where((element) => element.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id).toList(),
      TipoRegistroEnum.saida => _todasMovimentacoes.where((element) => element.tipoMovimentacao == TipoMovimentacaoEnum.saida.id).toList(),
    };
  }
}
