import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:flutter/material.dart';

class ValorSegmentedButton extends StatelessWidget {
  const ValorSegmentedButton({required this.titulo, required this.valor, required this.selecionada, super.key});

  final String titulo;
  final double valor;
  final bool selecionada;

  @override
  Widget build(BuildContext context) {
    final color = selecionada ? context.colorScheme.onPrimary : context.colorScheme.onTertiaryContainer;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          titulo,
          style: TextStyle(color: color),
        ),
        Text(
          '${Strings.RS} ${Moeda.format(valor: valor)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
