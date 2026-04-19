import 'package:budgetopia/common/components/combo_box/cyber_combo_box.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class TipoMovimentacao extends StatefulWidget {
  const TipoMovimentacao({required this.focusNode, required this.nextFocusNode, super.key});

  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  State<TipoMovimentacao> createState() => _TipoMovimentacaoState();
}

class _TipoMovimentacaoState extends State<TipoMovimentacao> with DDIInject<MovimentacaoController> {
  late final List<CyberComboBoxOption<TipoMovimentacaoEnum>> _options;

  @override
  void initState() {
    super.initState();
    _options = TipoMovimentacaoEnum.values
        .map(
          (item) => CyberComboBoxOption<TipoMovimentacaoEnum>(
            value: item,
            label: item.nome,
            icon: Image.asset(
              'assets/icons/${item.icone}',
              width: 24,
              height: 24,
            ),
          ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return CyberComboBoxField<TipoMovimentacaoEnum>(
      label: Strings.TIPO_TRANSACAO,
      options: _options,
      valueListenable: instance.tipoMovimentacao,
      focusNode: widget.focusNode,
      onChanged: instance.selecionarTipoMovimentacao,
      onSubmitted: widget.nextFocusNode.requestFocus,
    );
  }
}
