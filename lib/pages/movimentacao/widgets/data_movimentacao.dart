import 'package:budgetopia/pages/movimentacao/controller/data_movimentacao_controller.dart';
import 'package:budgetopia/pages/movimentacao/state/data_selecionar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DataMovimentacao extends StatefulWidget {
  const DataMovimentacao({required this.focusNode, super.key});

  final FocusNode focusNode;

  @override
  State<DataMovimentacao> createState() => _DataMovimentacaoState();
}

class _DataMovimentacaoState extends EventListenerState<DataMovimentacao, DataSelecionarState> with DDIInject<DataMovimentacaoController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => instance.selecionarDataMovimentacao(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: '${instance.dataSelecionada.toLocal()}'.split(' ')[0],
          ),
          focusNode: widget.focusNode,
          decoration: const InputDecoration(
            labelText: 'Data',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}