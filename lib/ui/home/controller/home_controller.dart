import 'dart:async';

import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/repository/home/home_repository.dart';
import 'package:budgetopia/ui/home/case/home_case.dart';
import 'package:budgetopia/ui/home/state/home_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeController extends ValueNotifier<HomeState> with PostConstruct, PreDestroy {
  HomeController()
    : super(HomeState(tabSelecionada: {TipoRegistroEnum.todos}, valorEntrada: 0, valorSaida: 0, valorSaldo: 0));

  late final HomeRepository _homeRepository = ddi();
  late final HomeCase _homeCase = ddi();

  List<MovimentacaoModel> get registrosAbaMovimentacao => _homeRepository.movimentacoesPorAba.reversed.toList();

  late final StreamSubscription<Map<String, List<MovimentacaoModel>>> _streamRef;
  late final StreamSubscription<int> _streamSliderRef;

  @override
  FutureOr<void> onPostConstruct() {
    _streamSliderRef = _homeCase.slidePosition.listen(alterouSelecao);

    _streamRef = _homeRepository.buscarDadosMovimentacao().listen((Map<String, List<MovimentacaoModel>> event) {
      double entrada = 0;
      double saida = 0;

      int posicaoSelecionada = 0;
      List<String> mesesDisponiveis = [];

      if (event.isNotEmpty) {
        //Somente será vazio quando for o primeiro evento disparado
        if (_homeRepository.movimentacoesMesSelecionado.isEmpty) {
          mesesDisponiveis = event.keys.toList();

          final DateTime now = DateTime.now();
          final int newPos = mesesDisponiveis.indexOf('${now.getFormattedMonth()}/${now.year}');

          posicaoSelecionada = newPos < 0 ? mesesDisponiveis.length - 1 : newPos;
        } else {
          final String mesSelecionado = _homeCase.getByPosicao;

          mesesDisponiveis = event.keys.toList();

          final int newPos = mesesDisponiveis.indexOf(mesSelecionado);

          posicaoSelecionada = newPos < 0 ? mesesDisponiveis.length - 1 : newPos;
        }

        final movimentacoesMesSelecionado = _homeRepository.filtrarMovimentacao(
          posicaoSelecionada,
          value.tabSelecionada.first,
        );

        for (final MovimentacaoModel item in movimentacoesMesSelecionado) {
          if (item.sugestao) {
            continue;
          }
          if (item.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id) {
            entrada += item.valor;
          } else {
            saida += item.valor;
          }
        }
      } else {
        mesesDisponiveis = [];
        posicaoSelecionada = 0;
      }
      _homeCase.changeScrollPosition(0);

      _homeCase.update(posicaoSelecionada, mesesDisponiveis);

      value = HomeState(
        tabSelecionada: value.tabSelecionada,
        valorEntrada: entrada,
        valorSaida: saida,
        valorSaldo: entrada - saida,
      );
    });
  }

  void refresh(Set<TipoRegistroEnum> tab) {
    _homeRepository.filtrarMovimentacaoAba(tab.first);

    value = value.copyWith(tabSelecionada: {tab.first});
  }

  void alterouSelecao(int pos) {
    final movimentacoesMesSelecionado = _homeRepository.filtrarMovimentacao(pos, value.tabSelecionada.first);

    double entrada = 0;
    double saida = 0;

    for (final MovimentacaoModel item in movimentacoesMesSelecionado) {
      if (item.sugestao) {
        continue;
      }
      if (item.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id) {
        entrada += item.valor;
      } else {
        saida += item.valor;
      }
    }
    _homeCase.changeScrollPosition(0);

    value = HomeState(
      tabSelecionada: value.tabSelecionada,
      valorEntrada: entrada,
      valorSaida: saida,
      valorSaldo: entrada - saida,
    );
  }

  bool confirmarSugestao(MovimentacaoModel sugestao) {
    return _homeRepository.confirmarSugestao(sugestao);
  }

  @override
  FutureOr<void> onPreDestroy() {
    _streamRef.cancel();
    _streamSliderRef.cancel();
  }
}
