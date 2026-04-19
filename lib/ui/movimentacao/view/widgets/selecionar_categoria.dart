import 'package:budgetopia/common/components/combo_box/cyber_combo_box.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class SelecionarCategoria extends StatefulWidget {
  const SelecionarCategoria({required this.focusNode, required this.nextFocusNode, super.key});

  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  State<SelecionarCategoria> createState() => _SelecionarCategoriaState();
}

class _SelecionarCategoriaState extends State<SelecionarCategoria> with DDIInject<MovimentacaoController> {
  late final List<CyberComboBoxOption<CategoriaEnum>> _options;

  @override
  void initState() {
    super.initState();
    _options = CategoriaEnum.values
        .map(
          (category) => CyberComboBoxOption<CategoriaEnum>(
            value: category,
            label: category.nome,
            icon: Image.asset(
              'assets/icons/${category.icone}',
              width: 24,
              height: 24,
            ),
          ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return CyberComboBoxField<CategoriaEnum>(
      label: Strings.CATEGORIA,
      options: _options,
      valueListenable: instance.categoria,
      focusNode: widget.focusNode,
      onChanged: instance.selecionarCategoria,
      onSubmitted: widget.nextFocusNode.requestFocus,
    );
  }
}
