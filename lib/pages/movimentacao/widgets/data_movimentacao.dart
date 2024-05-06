import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/pages/movimentacao/controller/data_movimentacao_controller.dart';
import 'package:budgetopia/pages/movimentacao/state/data_selecionar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DataMovimentacao extends StatefulWidget {
  const DataMovimentacao({required this.focusNode, required this.nextFocus, super.key});

  final FocusNode focusNode;
  final FocusNode nextFocus;

  @override
  State<DataMovimentacao> createState() => _DataMovimentacaoState();
}

class _DataMovimentacaoState extends EventListenerState<DataMovimentacao, DataSelecionarState> with DDIInject<DataMovimentacaoController> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(openDataFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(openDataFocus);
    super.dispose();
  }

  void openDataFocus() async {
    if (widget.focusNode.hasFocus) {
      context.closeKeyboard();
      await instance.selecionarDataMovimentacao();
      widget.nextFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(
        text: instance.dataSelecionada.format(),
      ),
      focusNode: widget.focusNode,
      onTap: () async {
        context.closeKeyboard();
        await instance.selecionarDataMovimentacao();
        widget.nextFocus.requestFocus();
      },
      onEditingComplete: widget.nextFocus.requestFocus,
      textInputAction: TextInputAction.next,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Data',
        prefixIcon: SizedBox(
          width: 40,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 6),
              child: FaIcon(
                FontAwesomeIcons.calendarCheck,
                size: 20,
              ),
            ),
          ),
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
}
