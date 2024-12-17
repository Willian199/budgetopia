import 'dart:async';

import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/repository/home/home_repository.dart';
import 'package:budgetopia/ui/home/case/home_case.dart';
import 'package:budgetopia/ui/home/state/home_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeController with DDIEventSender<HomeState>, PostConstruct, PreDestroy {
  late final HomeRepository _homeRepository = ddi();
  late final HomeCase _homeCase = ddi();

  List<MovimentacaoModel> get registrosAbaMovimentacao => _homeRepository.movimentacoesPorAba.reversed.toList();

  late final StreamSubscription<Map<String, List<MovimentacaoModel>>> _streamRef;
  late final StreamSubscription<int> _streamSliderRef;

  @override
  FutureOr<void> onPostConstruct() {
    _streamSliderRef = _homeCase.slidePosition.listen(alterouSelecao);

    _streamRef = _homeRepository.buscarDadosMovimentacao().listen((Map<String, List<MovimentacaoModel>> event) {
      print('buscarDadosMovimentacao');
      double entrada = 0;
      double saida = 0;

      int posicaoSelecionada = 0;
      List<String> mesesDisponiveis = [];

      if (event.isNotEmpty) {
        //Somente será vazio quando for o primeiro evento disparado
        if (_homeRepository.movimentacoesMesSelecionado.isEmpty) {
          mesesDisponiveis = event.keys.toList();

          final int newPos = mesesDisponiveis.indexOf(DateTime.now().getFormattedMonth());

          posicaoSelecionada = newPos < 0 ? mesesDisponiveis.length - 1 : newPos;
        } else {
          final String mesSelecionado = _homeCase.getByPosicao;

          mesesDisponiveis = event.keys.toList();

          final int newPos = mesesDisponiveis.indexOf(mesSelecionado);

          posicaoSelecionada = newPos < 0 ? mesesDisponiveis.length - 1 : newPos;
        }

        final movimentacoesMesSelecionado =
            _homeRepository.filtrarMovimentacao(posicaoSelecionada, state?.tabSelecionada.first ?? TipoRegistroEnum.todos);

        for (final MovimentacaoModel item in movimentacoesMesSelecionado) {
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

      fire(
        HomeState(
          tabSelecionada: state?.tabSelecionada ?? {TipoRegistroEnum.todos},
          valorEntrada: entrada,
          valorSaida: saida,
          valorSaldo: entrada - saida,
        ),
      );
    });
  }

  void refresh(Set<TipoRegistroEnum> value) {
    print('refresh');
    _homeRepository.filtrarMovimentacaoAba(value.first);

    fire(state?.copyWith(tabSelecionada: {value.first}) ??
        HomeState(
          tabSelecionada: {value.first},
          valorEntrada: 0,
          valorSaida: 0,
          valorSaldo: 0,
        ));
  }

  void alterouSelecao(int pos) {
    print('alterouSelecao');
    final movimentacoesMesSelecionado = _homeRepository.filtrarMovimentacao(pos, state!.tabSelecionada.first);

    double entrada = 0;
    double saida = 0;

    for (final MovimentacaoModel item in movimentacoesMesSelecionado) {
      if (item.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id) {
        entrada += item.valor;
      } else {
        saida += item.valor;
      }
    }
    _homeCase.changeScrollPosition(0);

    fire(
      HomeState(
        tabSelecionada: state!.tabSelecionada,
        valorEntrada: entrada,
        valorSaida: saida,
        valorSaldo: entrada - saida,
      ),
    );
  }

  @override
  FutureOr<void> onPreDestroy() {
    _streamRef.cancel();
    _streamSliderRef.cancel();
  }
}
