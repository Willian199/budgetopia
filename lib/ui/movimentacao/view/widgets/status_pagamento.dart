import 'package:budgetopia/common/constantes/double.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class StatusPagamento extends StatefulWidget {
  const StatusPagamento({super.key});

  @override
  State<StatusPagamento> createState() => _StatusPagamentoState();
}

class _StatusPagamentoState extends State<StatusPagamento> with DDIInject<MovimentacaoController> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Double.DEZ),
          child: Text(
            Strings.TRANSACAO_REALIZADA,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: instance.status,
          builder: (context, value, child) {
            return Switch.adaptive(
              value: value,
              inactiveThumbColor: colorScheme.error,
              inactiveTrackColor: colorScheme.onError,
              onChanged: instance.alterarStatus,
            );
          },
        ),
      ],
    );
  }
}
