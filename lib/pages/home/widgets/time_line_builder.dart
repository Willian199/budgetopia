import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/constantes/double.dart';
import 'package:budgetopia/pages/home/controller/time_line_opacity_controller.dart';
import 'package:budgetopia/pages/home/model/movimentacao_model.dart';
import 'package:budgetopia/pages/home/widgets/item_time_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TimeLineBuilder extends StatefulWidget {
  const TimeLineBuilder({
    required this.movimentacoes,
    required this.scrollGastosController,
    super.key,
  });
  final List<MovimentacaoModel> movimentacoes;

  final ScrollController scrollGastosController;

  @override
  State<TimeLineBuilder> createState() => _TimeLineBuilderState();
}

class _TimeLineBuilderState extends State<TimeLineBuilder> with DDIInject<TimeLineOpacityController> {
  @override
  Widget build(BuildContext context) {
    widget.scrollGastosController.addListener(() {
      widget.scrollGastosController.addListener(() {
        instance.changeTabSelecionada(widget.scrollGastosController.offset);
      });
    });

    return Timeline.tileBuilder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: widget.scrollGastosController,
      theme: TimelineThemeData(
        nodePosition: 0.3,
        color: AdaptiveTheme.of(context).theme.colorScheme.secondary,
        connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
              thickness: Double.TRES,
            ),
        indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
              size: Double.VINTE,
              position: 0.2,
            ),
      ),
      builder: TimelineTileBuilder.connectedFromStyle(
        itemCount: widget.movimentacoes.length,
        firstConnectorStyle: ConnectorStyle.transparent,
        lastConnectorStyle: ConnectorStyle.dashedLine,
        connectorStyleBuilder: (BuildContext context, int index) {
          return ConnectorStyle.solidLine;
        },
        indicatorStyleBuilder: (BuildContext context, int index) {
          return IndicatorStyle.outlined;
        },
        oppositeContentsBuilder: (BuildContext context, int index) {
          final MovimentacaoModel movimentacao = widget.movimentacoes[index];

          return SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.only(
                left: Double.QUINZE,
                top: Double.DEZESSETE,
              ),
              child: Text(
                movimentacao.data.toIso8601String(),
                style: const TextStyle(
                  fontSize: Double.QUATORZE,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        contentsBuilder: (BuildContext context, int index) {
          final MovimentacaoModel movimentacao = widget.movimentacoes[index];

          return ItemTimeLine(
            movimentacao: movimentacao,
          );
        },
      ),
    );
  }
}
