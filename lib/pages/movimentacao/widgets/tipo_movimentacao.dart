import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/pages/movimentacao/controller/tipo_movimentacao_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class TipoMovimentacao extends StatefulWidget {
  const TipoMovimentacao({required this.focusNode, super.key});
  final FocusNode focusNode;

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
          child: Text(item.nome),
        );
      }).toList(),
      onChanged: instance.selecionarTipoMovimentacao,
      focusNode: widget.focusNode,
      decoration: const InputDecoration(
        labelText: 'Tipo de Transação',
        border: OutlineInputBorder(),
      ),
    );
  }
}
