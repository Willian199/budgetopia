import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/pages/movimentacao/controller/categoria_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class SelecionarCategoria extends StatefulWidget {
  const SelecionarCategoria({required this.focusNode, super.key});

  final FocusNode focusNode;

  @override
  State<SelecionarCategoria> createState() => _SelecionarCategoriaState();
}

class _SelecionarCategoriaState extends EventListenerState<SelecionarCategoria, CategoriaEnum> with DDIInject<CategoriaController> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CategoriaEnum>(
      value: state ?? instance.listarCategorias.first,
      items: instance.listarCategorias.map((CategoriaEnum category) {
        return DropdownMenuItem(
          value: category,
          child: Row(
            children: [
              Image.asset(
                'assets/icons_categoria/${category.icone}',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(category.nome),
            ],
          ),
        );
      }).toList(),
      onChanged: instance.selecionarCategoria,
      focusNode: widget.focusNode,
      decoration: const InputDecoration(
        label: Text('Categoria'),
        contentPadding: EdgeInsets.only(
          top: 20,
          bottom: 20,
          right: 20,
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
}
