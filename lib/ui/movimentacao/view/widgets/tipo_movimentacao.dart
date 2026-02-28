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
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TipoMovimentacaoEnum>(
      initialValue: instance.tipoMovimentacao.value,
      items: TipoMovimentacaoEnum.values.map((TipoMovimentacaoEnum item) {
        return DropdownMenuItem(
          value: item,
          child: Row(
            children: [
              Image.asset(
                'assets/icons/${item.icone}',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(item.nome),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        instance.selecionarTipoMovimentacao(value);
        widget.nextFocusNode.requestFocus();
      },
      focusNode: widget.focusNode,
      decoration: const InputDecoration(
        labelText: 'Tipo de Transação',
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
