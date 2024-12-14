import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/controller/selecao_horizontal_controller.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/data/service/home/home_service.dart';
import 'package:budgetopia/ui/home/controller/time_line_opacity_controller.dart';
import 'package:budgetopia/ui/home/module/home_module.dart';
import 'package:budgetopia/ui/home/state/home_state.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeController with DDIEventSender<HomeState>, PostConstruct, PreDestroy {
  late final HomeService _homeService = ddi();
  late final TimeLineOpacityController _timeLineOpacityController = ddi();
  late final SelecaoHorizontalController _selecaoHorizontalController = ddi.getComponent(module: HomeModule);

  List<MovimentacaoModel> get registrosAbaMovimentacao => _homeService.movimentacoesPorAba.reversed.toList();

  late final StreamSubscription<Map<String, List<MovimentacaoModel>>> _streamRef;

  @override
  FutureOr<void> onPostConstruct() {
    _streamRef = _homeService.buscarDadosMovimentacao().listen((Map<String, List<MovimentacaoModel>> event) {
      double entrada = 0;
      double saida = 0;

      int posicaoSelecionada = 0;
      List<String> mesesDisponiveis = [];

      if (event.isNotEmpty) {
        //Somente será vazio quando for o primeiro evento disparado
        if (_homeService.movimentacoesMesSelecionado.isEmpty) {
          mesesDisponiveis = event.keys.toList();

          final int newPos = mesesDisponiveis.indexOf(DateTime.now().getFormattedMonth());

          posicaoSelecionada = newPos < 0 ? mesesDisponiveis.length - 1 : newPos;
        } else {
          final String mesSelecionado = _selecaoHorizontalController.itens[_selecaoHorizontalController.posicao];

          mesesDisponiveis = event.keys.toList();

          final int newPos = mesesDisponiveis.indexOf(mesSelecionado);

          posicaoSelecionada = newPos < 0 ? mesesDisponiveis.length - 1 : newPos;
        }

        final movimentacoesMesSelecionado =
            _homeService.filtrarMovimentacao(posicaoSelecionada, state?.tabSelecionada.first ?? TipoRegistroEnum.todos);

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
      _timeLineOpacityController.changePosition(0);

      _selecaoHorizontalController.setDados(posicaoSelecionada, mesesDisponiveis);

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
    _homeService.filtrarMovimentacaoAba(value.first);

    fire(state?.copyWith(tabSelecionada: {value.first}) ??
        HomeState(
          tabSelecionada: {value.first},
          valorEntrada: 0,
          valorSaida: 0,
          valorSaldo: 0,
        ));
  }

  void alterouSelecao(int pos) {
    final movimentacoesMesSelecionado = _homeService.filtrarMovimentacao(pos, state!.tabSelecionada.first);

    double entrada = 0;
    double saida = 0;

    for (final MovimentacaoModel item in movimentacoesMesSelecionado) {
      if (item.tipoMovimentacao == TipoMovimentacaoEnum.entrada.id) {
        entrada += item.valor;
      } else {
        saida += item.valor;
      }
    }

    _timeLineOpacityController.changePosition(0);

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
  }
}
