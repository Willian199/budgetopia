import 'dart:async';

import 'package:budgetopia/common/components/selecao_horizontal/config/update_interface.dart';
import 'package:budgetopia/common/components/selecao_horizontal/controller/selecao_horizontal_controller.dart';
import 'package:budgetopia/common/extensions/completer_extension.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HorizontalSelecaoMes<ModuleT extends DDIModule, CaseT extends UpdateInterface> extends StatefulWidget {
  const HorizontalSelecaoMes({super.key});

  @override
  State<HorizontalSelecaoMes> createState() => _HorizontalSelecaoMesState<ModuleT, CaseT>();
}

class _HorizontalSelecaoMesState<ModuleT extends DDIModule, CaseT extends UpdateInterface> extends State<HorizontalSelecaoMes> {
  late final PageController _pageController;

  final Completer<void> complete = Completer();

  final SelecaoHorizontalController<CaseT> instance = ddi.get(qualifier: '$ModuleT${SelecaoHorizontalController<CaseT>}');
  @override
  void initState() {
    super.initState();
    instance.addListener(_onEvent);

    instance.alterouPosicao(0);

    complete.onComplete((_) => _pageController.jumpToPage(instance.value.posicao));

    _pageController = PageController(
      onAttach: (position) {
        if (!complete.isCompleted) {
          complete.complete();
        }
      },
    );
  }

  void _onEvent() {
    if (complete.isCompleted) {
      if (((_pageController.page?.toInt() ?? 0).abs() - instance.value.posicao).abs() > 1) {
        _pageController.jumpToPage(instance.value.posicao);
      } else {
        _pageController.animateToPage(instance.value.posicao, duration: Durations.medium2, curve: Curves.linear);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    instance.removeListener(_onEvent);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: instance,
      builder: (context, child) {
        if (instance.value.itens.isEmpty) {
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
                onPressed: (instance.value.posicao) > 0
                    ? () {
                        _pageController.animateToPage(
                          instance.value.posicao - 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
              SizedBox(
                height: 80,
                width: width - 150,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: instance.value.itens.length,
                  onPageChanged: instance.updatePosition,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Text(
                        instance.value.itens[index].capitalize,
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
                onPressed: (instance.value.posicao) < (instance.value.itens.length) - 1 // Altere o valor máximo conforme necessário
                    ? () {
                        final int pos = instance.value.posicao + 1;
                        _pageController.animateToPage(pos, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
