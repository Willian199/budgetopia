import 'package:budgetopia/pages/home/controller/home_controller.dart';
import 'package:budgetopia/pages/home/state/home_state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HorizontalSelecaoMes extends StatefulWidget {
  @override
  State<HorizontalSelecaoMes> createState() => _HorizontalSelecaoMesState();
}

class _HorizontalSelecaoMesState extends State<HorizontalSelecaoMes> with DDIInject<HomeController> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();

    _pageController = instance.pageController;

    ddiEvent.subscribe<HomeState>(
      (HomeState _) {
        Future.delayed(Durations.medium1, () {
          _pageController.jumpToPage(instance.posicaoSelecionada);
        });
      },
      unsubscribeAfterFire: true,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Este método será chamado quando o PageView terminar de ser construído

  @override
  Widget build(BuildContext context) {
    if (instance.mesesDisponiveis.isEmpty) {
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
            onPressed: instance.posicaoSelecionada > 0
                ? () {
                    _pageController.animateToPage(instance.posicaoSelecionada - 1,
                        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                  }
                : null,
          ),
          SizedBox(
            height: 80,
            width: width - 150,
            child: PageView.builder(
              controller: _pageController,
              itemCount: instance.mesesDisponiveis.length,
              onPageChanged: instance.alterouSelecao,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    instance.mesesDisponiveis[index].capitalize,
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
            onPressed: instance.posicaoSelecionada < instance.mesesDisponiveis.length - 1 // Altere o valor máximo conforme necessário
                ? () {
                    final int pos = instance.posicaoSelecionada + 1;
                    _pageController.animateToPage(pos, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
