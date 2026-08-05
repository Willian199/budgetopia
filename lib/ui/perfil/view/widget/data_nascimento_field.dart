import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/ui/perfil/controller/data_nascimento_controller.dart';
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

class _DataNascimentoFieldState extends ListenableState<DataNascimentoField, DataNascimentoController> {
  late final _dateTextController = TextEditingController(
    text: super.listenable.value.format(),
  );

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_openDataFocus);
    super.listenable.addListener(_refreshTextField);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_openDataFocus);
    super.listenable.removeListener(_refreshTextField);
    _dateTextController.dispose();
    super.dispose();
  }

  void _openDataFocus() async {
    if (widget.focusNode.hasFocus) {
      context.closeKeyboard();
      await super.listenable.selecionarDataNascimento();
      widget.nextFocus.requestFocus();
    }
  }

  void _refreshTextField() {
    _dateTextController.text = super.listenable.value.format();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Theme colors
    final primaryColor = theme.colorScheme.primary;
    final backgroundColor = theme.colorScheme.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Row(
            spacing: 6,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                Strings.DATA_NASCIMENTO,
                style: TextStyle(
                  fontSize: 13,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Date input field
        TextFormField(
          controller: _dateTextController,
          focusNode: widget.focusNode,
          readOnly: true,
          onTap: () async {
            context.closeKeyboard();
            await super.listenable.selecionarDataNascimento();
            widget.nextFocus.requestFocus();
          },
          onEditingComplete: widget.nextFocus.requestFocus,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: primaryColor.withAlpha(77),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: primaryColor.withAlpha(77),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: primaryColor,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: backgroundColor.withAlpha(200),
            prefixIcon: Container(
              width: 50,
              padding: const EdgeInsets.only(left: 6),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.calendarCheck,
                  size: 20,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          style: TextStyle(
            fontSize: 16,
            color: primaryColor.withAlpha(230),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
