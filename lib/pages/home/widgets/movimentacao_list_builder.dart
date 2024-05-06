import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/pages/home/controller/home_controller.dart';
import 'package:budgetopia/pages/home/controller/time_line_opacity_controller.dart';
import 'package:budgetopia/pages/home/widgets/item_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class MovimentacaoListBuilder extends StatefulWidget {
  @override
  State<MovimentacaoListBuilder> createState() => _MovimentacaoListBuilderState();
}

class _MovimentacaoListBuilderState extends State<MovimentacaoListBuilder> with SingleTickerProviderStateMixin, DDIInject<TimeLineOpacityController> {
  late AnimationController _controller;

  final ScrollController _scrollGastosController = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Future.delayed(Duration.zero, () {
      _controller.forward(from: 0.0);
    });

    _scrollGastosController.addListener(updatePosition);
  }

  void updatePosition() {
    instance.changePosition(_scrollGastosController.offset);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollGastosController.removeListener(updatePosition);
    _scrollGastosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<MovimentacaoModel> registrosMovimentacao = context.get<HomeController>().registrosAbaMovimentacao;
    return ImplicitlyAnimatedList<MovimentacaoModel>(
      controller: _scrollGastosController,
      spawnIsolate: false,
      items: registrosMovimentacao,
      areItemsTheSame: (a, b) => a.id == b.id,
      itemBuilder: (context, animation, item, index) {
        return SizeTransition(
          sizeFactor: animation,
          axisAlignment: 1,
          fixedCrossAxisSizeFactor: 10,
          child: ItemListTile(
            item: item,
            isLast: index == registrosMovimentacao.length - 1,
          ),
        );
      },
    );
  }
}
