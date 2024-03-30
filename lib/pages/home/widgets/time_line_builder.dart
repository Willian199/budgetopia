import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/constantes/double.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/pages/home/controller/time_line_opacity_controller.dart';
import 'package:budgetopia/pages/home/widgets/item_time_line.dart';
import 'package:budgetopia/pages/movimentacao/model/movimentacao_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TimeLineBuilder extends StatefulWidget {
  const TimeLineBuilder({
    required this.scrollGastosController,
    this.registrosMovimentacao,
    super.key,
  });

  final ScrollController scrollGastosController;
  final List<MovimentacaoModel>? registrosMovimentacao;

  @override
  State<TimeLineBuilder> createState() => _TimeLineBuilderState();
}

class _TimeLineBuilderState extends State<TimeLineBuilder> with DDIInject<TimeLineOpacityController> {
  @override
  void initState() {
    super.initState();

    widget.scrollGastosController.addListener(() {
      instance.changePosition(widget.scrollGastosController.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building TimeLineBuilder');
    if (widget.registrosMovimentacao == null) {
      return const SizedBox();
    }
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
        itemCount: widget.registrosMovimentacao!.length,
        firstConnectorStyle: ConnectorStyle.transparent,
        lastConnectorStyle: ConnectorStyle.dashedLine,
        connectorStyleBuilder: (BuildContext context, int index) {
          return ConnectorStyle.solidLine;
        },
        indicatorStyleBuilder: (BuildContext context, int index) {
          return IndicatorStyle.outlined;
        },
        oppositeContentsBuilder: (BuildContext context, int index) {
          final MovimentacaoModel movimentacao = widget.registrosMovimentacao![index];

          return SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.only(
                left: Double.QUINZE,
                top: Double.VINTE,
              ),
              child: Text(
                movimentacao.data.format(),
                style: const TextStyle(
                  fontSize: Double.QUATORZE,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        contentsBuilder: (BuildContext context, int index) {
          final MovimentacaoModel movimentacao = widget.registrosMovimentacao![index];

          return ItemTimeLine(
            movimentacao: movimentacao,
          );
        },
      ),
    );
  }
}
