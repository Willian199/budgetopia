import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/config/update_interface.dart';
import 'package:budgetopia/common/components/selecao_horizontal/controller/selecao_horizontal_controller.dart';
import 'package:budgetopia/common/components/selecao_horizontal/state/selecao_horizontal_state.dart';
import 'package:budgetopia/common/extensions/completer_extension.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HorizontalSelecaoMes<ModuleT extends DDIModule, CaseT extends UpdateInterface> extends StatefulWidget {
  const HorizontalSelecaoMes({super.key});

  @override
  State<HorizontalSelecaoMes> createState() => _HorizontalSelecaoMesState<ModuleT, CaseT>();
}

class _HorizontalSelecaoMesState<ModuleT extends DDIModule, CaseT extends UpdateInterface>
    extends EventListenerState<HorizontalSelecaoMes, SelecaoHorizontalState> with DDIComponentInject<SelecaoHorizontalController<CaseT>, ModuleT> {
  late final PageController _pageController;

  final Completer<void> complete = Completer();
  @override
  void initState() {
    super.initState();

    instance.alterouPosicao(0);

    complete.onComplete((_) => _pageController.jumpToPage(state?.posicao ?? 0));

    _pageController = PageController(
      onAttach: (position) {
        if (!complete.isCompleted) {
          complete.complete();
        }
      },
    );
  }

  @override
  void onEvent(SelecaoHorizontalState state) {
    super.onEvent(state);

    if (complete.isCompleted) {
      if (((_pageController.page?.toInt() ?? 0).abs() - state.posicao).abs() > 1) {
        _pageController.jumpToPage(state.posicao);
      } else {
        _pageController.animateToPage(state.posicao, duration: Durations.medium2, curve: Curves.linear);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (state?.itens.isEmpty ?? true) {
      return const Center(
        child: Text('Nenhum mês disponível'),
      );
    }

    final double width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      width: width,
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            constraints: BoxConstraints.loose(const Size(30, 30)),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Center(child: Icon(Icons.arrow_back)),
            onPressed: (state?.posicao ?? 0) > 0
                ? () {
                    _pageController.animateToPage(state!.posicao - 1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                  }
                : null,
          ),
          SizedBox(
            height: 80,
            width: width - 150,
            child: PageView.builder(
              controller: _pageController,
              itemCount: state?.itens.length ?? 0,
              onPageChanged: instance.updatePosition,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    state!.itens[index].capitalize,
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
          ),
          IconButton(
            constraints: BoxConstraints.loose(const Size(30, 30)),
            icon: const Icon(Icons.arrow_forward),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: (state?.posicao ?? 0) < (state?.itens.length ?? 0) - 1 // Altere o valor máximo conforme necessário
                ? () {
                    final int pos = state!.posicao + 1;
                    _pageController.animateToPage(pos, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
