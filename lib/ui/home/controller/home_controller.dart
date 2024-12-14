import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/controller/selecao_horizontal_controller.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/service/movimentacao/movimentacao_service.dart';
import 'package:budgetopia/ui/home/controller/time_line_opacity_controller.dart';
import 'package:budgetopia/ui/home/module/home_module.dart';
import 'package:budgetopia/ui/home/state/home_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeController with DDIEventSender<HomeState>, PostConstruct, PreDestroy {
  HomeController(this._movimentacaoService, this._timeLineOpacityController);

  final MovimentacaoService _movimentacaoService;
  final TimeLineOpacityController _timeLineOpacityController;
  late final SelecaoHorizontalController _selecaoHorizontalController = ddi.getComponent(module: HomeModule);

  Map<String, List<MovimentacaoModel>> _todasMovimentacoes = {};

  List<MovimentacaoModel> _movimentacoesMesSelecionado = [];

  late List<MovimentacaoModel> _registrosAbaMovimentacao;

  List<MovimentacaoModel> get registrosAbaMovimentacao => _registrosAbaMovimentacao.reversed.toList();

  TipoRegistroEnum _tabSelecionada = TipoRegistroEnum.todos;
  TipoRegistroEnum get tabSelecionada => _tabSelecionada;

  late final StreamSubscription<Map<String, List<MovimentacaoModel>>> _streamRef;

  @override
  FutureOr<void> onPostConstruct() {
    _streamRef = _movimentacaoService.buscarDadosMovimentacao().listen((Map<String, List<MovimentacaoModel>> event) {
      _todasMovimentacoes = event;

      double entrada = 0;
      double saida = 0;

      int posicaoSelecionada = 0;
      List<String> mesesDisponiveis = [];

      if (event.isNotEmpty) {
        //Somente será vazio quando for o primeiro evento disparado
        if (_movimentacoesMesSelecionado.isEmpty) {
          mesesDisponiveis = event.keys.toList();

          final int newPos = mesesDisponiveis.indexOf(DateTime.now().getFormattedMonth());

          posicaoSelecionada = newPos < 0 ? mesesDisponiveis.length - 1 : newPos;
        } else {
          final String mesSelecionado = _selecaoHorizontalController.itens[_selecaoHorizontalController.posicao];

          mesesDisponiveis = event.keys.toList();

          final int newPos = mesesDisponiveis.indexOf(mesSelecionado);

          posicaoSelecionada = newPos < 0 ? mesesDisponiveis.length - 1 : newPos;
        }

        _movimentacoesMesSelecionado = _todasMovimentacoes.entries.elementAt(posicaoSelecionada).value;

        _filtrarMovimentacaoes();

        for (final MovimentacaoModel item in _movimentacoesMesSelecionado) {
          if (item.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id) {
            entrada += item.valor;
          } else {
            saida += item.valor;
          }
        }
      } else {
        _movimentacoesMesSelecionado = [];
        mesesDisponiveis = [];
        posicaoSelecionada = 0;
      }
      _timeLineOpacityController.changePosition(0);

      _selecaoHorizontalController.setDados(posicaoSelecionada, mesesDisponiveis);

      fire(
        HomeState(
          tabSelecionada: {_tabSelecionada},
          valorEntrada: entrada,
          valorSaida: saida,
          valorSaldo: entrada - saida,
        ),
      );
    });
  }

  void refresh(Set<TipoRegistroEnum> value) {
    _tabSelecionada = value.first;
    _filtrarMovimentacaoes();
    fire(state?.copyWith(tabSelecionada: {_tabSelecionada}) ??
        HomeState(
          tabSelecionada: {TipoRegistroEnum.todos},
          valorEntrada: 0,
          valorSaida: 0,
          valorSaldo: 0,
        ));
  }

  void alterouSelecao(int pos) {
    _movimentacoesMesSelecionado = _todasMovimentacoes.entries.toList()[pos].value;

    _filtrarMovimentacaoes();

    double entrada = 0;
    double saida = 0;

    for (final MovimentacaoModel item in _movimentacoesMesSelecionado) {
      if (item.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id) {
        entrada += item.valor;
      } else {
        saida += item.valor;
      }
    }

    _timeLineOpacityController.changePosition(0);

    fire(
      HomeState(
        tabSelecionada: {_tabSelecionada},
        valorEntrada: entrada,
        valorSaida: saida,
        valorSaldo: entrada - saida,
      ),
    );
  }

  void _filtrarMovimentacaoes() {
    _registrosAbaMovimentacao = switch (_tabSelecionada) {
      TipoRegistroEnum.todos => _movimentacoesMesSelecionado,
      TipoRegistroEnum.entrada =>
        _movimentacoesMesSelecionado.where((element) => element.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id).toList(),
      TipoRegistroEnum.saida => _movimentacoesMesSelecionado.where((element) => element.tipoMovimentacao == TipoMovimentacaoEnum.saida.id).toList(),
    };
  }

  @override
  FutureOr<void> onPreDestroy() {
    _streamRef.cancel();
  }
}
