import 'package:budgetopia/common/utils/moeda.dart';
import 'package:flutter/material.dart';

class CardValor extends StatelessWidget {
  const CardValor({required this.titulo, required this.valor, super.key});

  final String titulo;
  final double valor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(titulo),
          Text(
            'R\$ ${Moeda.ajustarMoeda(valor: valor)}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
