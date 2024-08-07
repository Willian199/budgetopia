import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/controller/selecao_horizontal_controller.dart';
import 'package:budgetopia/common/components/selecao_horizontal/state/selecao_horizontal_state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HorizontalSelecaoMes<ModuleT extends DDIModule> extends StatefulWidget {
  const HorizontalSelecaoMes({super.key, this.onPageChanged});

  final void Function(int)? onPageChanged;

  @override
  State<HorizontalSelecaoMes> createState() => _HorizontalSelecaoMesState<ModuleT>();
}

class _HorizontalSelecaoMesState<ModuleT extends DDIModule> extends State<HorizontalSelecaoMes>
    with DDIComponentInject<SelecaoHorizontalController, ModuleT> {
  final Completer<void> _complete = Completer();

  late final PageController _pageController;
  @override
  void initState() {
    ddiEvent.subscribe<SelecaoHorizontalState>(listen);
    super.initState();

    _pageController = PageController(
      onAttach: (position) {
        if (!_complete.isCompleted) {
          _complete.complete();
        }
      },
    );

    ddiEvent.subscribe<SelecaoHorizontalState>(listen);
  }

  @override
  void dispose() {
    _pageController.dispose();
    ddiEvent.unsubscribe(listen);
    super.dispose();
  }

  Future<void> listen(SelecaoHorizontalState state) async {
    setState(() {});
    if (!_complete.isCompleted) {
      await _complete.future;
      _pageController.jumpToPage(state.posicao);
    } else {
      _pageController.animateToPage(state.posicao, duration: Durations.medium1, curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (instance.itens.isEmpty) {
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
            onPressed: instance.posicao > 0
                ? () {
                    _pageController.animateToPage(instance.posicao - 1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                  }
                : null,
          ),
          SizedBox(
            height: 80,
            width: width - 150,
            child: PageView.builder(
              controller: _pageController,
              itemCount: instance.itens.length,
              onPageChanged: (int posicao) {
                instance.alterouPosicao(posicao);
                widget.onPageChanged?.call(posicao);
              },
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    instance.itens[index].capitalize,
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
            onPressed: instance.posicao < instance.itens.length - 1 // Altere o valor máximo conforme necessário
                ? () {
                    final int pos = instance.posicao + 1;
                    _pageController.animateToPage(pos, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
