import 'package:budgetopia/common/components/combo_box/cyber_combo_box.dart';
import 'package:budgetopia/common/enum/tipo_recorrencia_enum.dart';
import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class TipoRecorrencia extends StatefulWidget {
  const TipoRecorrencia({
    required this.focusNode,
    required this.nextFocusNode,
    super.key,
  });

  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  State<TipoRecorrencia> createState() => _TipoRecorrenciaState();
}

class _TipoRecorrenciaState extends State<TipoRecorrencia> with DDIInject<MovimentacaoController> {
  late final List<CyberComboBoxOption<TipoRecorrenciaEnum>> _options;

  @override
  void initState() {
    super.initState();
    _options = TipoRecorrenciaEnum.values
        .map(
          (item) => CyberComboBoxOption<TipoRecorrenciaEnum>(
            value: item,
            label: item.nome,
            icon: Icon(
              switch (item) {
                TipoRecorrenciaEnum.diaria => Icons.today_outlined,
                TipoRecorrenciaEnum.semanal => Icons.calendar_view_week_outlined,
                TipoRecorrenciaEnum.quinzenal => Icons.date_range_outlined,
                TipoRecorrenciaEnum.mensal => Icons.calendar_month_outlined,
                TipoRecorrenciaEnum.intervaloDias => Icons.repeat_on_outlined,
              },
            ),
          ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return CyberComboBoxField<TipoRecorrenciaEnum>(
      label: 'Tipo de Recorrencia',
      options: _options,
      valueListenable: instance.tipoRecorrencia,
      focusNode: widget.focusNode,
      onChanged: instance.alterarTipoRecorrencia,
      onSubmitted: widget.nextFocusNode.requestFocus,
    );
  }
}
