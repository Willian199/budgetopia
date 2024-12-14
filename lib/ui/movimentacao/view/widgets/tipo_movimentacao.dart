import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/ui/movimentacao/controller/tipo_movimentacao_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class TipoMovimentacao extends StatefulWidget {
  const TipoMovimentacao({required this.focusNode, required this.nextFocusNode, super.key});
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  State<TipoMovimentacao> createState() => _TipoMovimentacaoState();
}

class _TipoMovimentacaoState extends EventListenerState<TipoMovimentacao, TipoMovimentacaoEnum> with DDIInject<TipoMovimentacaoController> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TipoMovimentacaoEnum>(
      value: state ?? instance.listarTiposMovimentacao.first,
      items: instance.listarTiposMovimentacao.map((TipoMovimentacaoEnum item) {
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
