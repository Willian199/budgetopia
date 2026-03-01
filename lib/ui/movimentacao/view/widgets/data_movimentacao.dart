import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/fields/info_fields.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
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

class _DataMovimentacaoState extends State<DataMovimentacao> with DDIInject<MovimentacaoController> {
  final TextEditingController _dataController = TextEditingController();
  bool _isSelectingDate = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_openDataFocus);
    instance.data.addListener(_definirData);
    _definirData();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_openDataFocus);
    instance.data.removeListener(_definirData);
    super.dispose();
  }

  void _openDataFocus() async {
    if (!widget.focusNode.hasFocus) {
      return;
    }
    await _openDatePicker();
  }

  void _definirData() {
    _dataController.text = instance.data.value.format();
  }

  Future<void> _openDatePicker() async {
    if (_isSelectingDate) {
      return;
    }

    _isSelectingDate = true;
    context.closeKeyboard();
    final bool hasSelected = await instance.selecionarDataMovimentacao();
    _isSelectingDate = false;

    if (!mounted) {
      return;
    }
    if (hasSelected) {
      widget.nextFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdaptiveTheme.of(context).theme;
    final isDarkMode = theme.brightness == Brightness.dark;

    // Theme colors
    final primaryColor = theme.colorScheme.primary;
    final backgroundColor = isDarkMode
        ? const Color(0xFF002215) // Dark theme background
        : const Color(0xFFebffe5); // Light theme background

    return InfoFields(
      label: Strings.DATA,
      icon: FontAwesomeIcons.calendarCheck,
      controller: _dataController,
      focusNode: widget.focusNode,
      validator: (_) => null,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      nextFocus: widget.nextFocus,
      onTap: () async {
        _dataController.selection = const TextSelection(baseOffset: 0, extentOffset: 0);
        if (!widget.focusNode.hasFocus) {
          widget.focusNode.requestFocus();
          return;
        }
        await _openDatePicker();
      },
      onEditingComplete: widget.nextFocus.requestFocus,
      readOnly: true,
    );
  }
}
