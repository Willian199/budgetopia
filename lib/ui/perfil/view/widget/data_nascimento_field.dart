import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/ui/perfil/controller/data_nascimento_controller.dart';
import 'package:budgetopia/ui/perfil/state/data_nascimento_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DataNascimentoField extends StatefulWidget {
  const DataNascimentoField({required this.focusNode, required this.nextFocus, super.key});

  final FocusNode focusNode;
  final FocusNode nextFocus;

  @override
  State<DataNascimentoField> createState() => _DataNascimentoFieldState();
}

class _DataNascimentoFieldState extends EventListenerState<DataNascimentoField, DataNascimentoState> with DDIInject<DataNascimentoController> {
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
      await instance.selecionarDataNascimento();
      widget.nextFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(
        text: instance.dataNascimento.format(),
      ),
      focusNode: widget.focusNode,
      readOnly: true,
      onTap: () async {
        context.closeKeyboard();
        await instance.selecionarDataNascimento();
        widget.nextFocus.requestFocus();
      },
      onEditingComplete: widget.nextFocus.requestFocus,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Data de Nascimento',
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
