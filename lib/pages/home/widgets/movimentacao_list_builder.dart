import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:budgetopia/pages/home/controller/time_line_opacity_controller.dart';
import 'package:budgetopia/pages/home/widgets/item_list_tile.dart';
import 'package:budgetopia/pages/movimentacao/model/movimentacao_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class MovimentacaoListBuilder extends StatefulWidget {
  const MovimentacaoListBuilder({required this.scrollGastosController, super.key, this.registrosMovimentacao});

  final ScrollController scrollGastosController;
  final List<MovimentacaoModel>? registrosMovimentacao;

  @override
  State<MovimentacaoListBuilder> createState() => _MovimentacaoListBuilderState();
}

class _MovimentacaoListBuilderState extends State<MovimentacaoListBuilder> with SingleTickerProviderStateMixin, DDIInject<TimeLineOpacityController> {
  late AnimationController _controller;

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

    widget.scrollGastosController.addListener(() {
      instance.changePosition(widget.scrollGastosController.offset);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ImplicitlyAnimatedList<MovimentacaoModel>(
      controller: widget.scrollGastosController,
      spawnIsolate: false,
      items: widget.registrosMovimentacao ?? [],
      areItemsTheSame: (a, b) => a.id == b.id,
      itemBuilder: (context, animation, item, index) {
        return SizeTransition(
          sizeFactor: animation,
          axisAlignment: 1,
          fixedCrossAxisSizeFactor: 10,
          child: ItemListTile(
            item: item,
            isLast: index == widget.registrosMovimentacao!.length - 1,
          ),
        );
      },
    );
  }
}
