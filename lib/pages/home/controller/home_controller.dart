import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/controller/selecao_horizontal_controller.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/banco/repository/movimentacao/movimentacao_repository.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/pages/home/controller/time_line_opacity_controller.dart';
import 'package:budgetopia/pages/home/module/home_module.dart';
import 'package:budgetopia/pages/home/state/home_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeController with DDIEventSender<HomeState>, PostConstruct {
  HomeController()
      : _movimentacaoRepository = ddi(),
        _timeLineOpacityController = ddi(),
        _selecaoHorizontalController = ddi.getComponent(module: HomeModule);

  final MovimentacaoRepository _movimentacaoRepository;
  final TimeLineOpacityController _timeLineOpacityController;
  final SelecaoHorizontalController _selecaoHorizontalController;

  Map<String, List<MovimentacaoModel>> _todasMovimentacoes = {};

  List<MovimentacaoModel> _movimentacoesMesSelecionado = [];

  late List<MovimentacaoModel> _registrosAbaMovimentacao;

  List<MovimentacaoModel> get registrosAbaMovimentacao => _registrosAbaMovimentacao.reversed.toList();

  TipoRegistroEnum _tabSelecionada = TipoRegistroEnum.todos;
  TipoRegistroEnum get tabSelecionada => _tabSelecionada;

  @override
  HomeState get state =>
      super.state ??
      HomeState(
        tabSelecionada: {TipoRegistroEnum.todos},
        valorEntrada: 0,
        valorSaida: 0,
        valorSaldo: 0,
      );

  @override
  FutureOr<void> onPostConstruct() {
    _movimentacaoRepository.filter().listen((Map<String, List<MovimentacaoModel>> event) {
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
    fire(state.copyWith(tabSelecionada: {_tabSelecionada}));
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
}
