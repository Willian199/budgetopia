import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/pages/movimentacao/model/movimentacao_model.dart';
import 'package:flutter/material.dart';

class ItemTimeLine extends StatelessWidget {
  const ItemTimeLine({required this.movimentacao, super.key});

  final MovimentacaoModel movimentacao;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = AdaptiveTheme.of(context).theme.colorScheme;

    return Container(
      height: 86,
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.2),
            spreadRadius: 6,
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          splashColor: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  movimentacao.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  CategoriaEnum.getById(movimentacao.codigoCategoria)?.nome ?? '',
                  style: TextStyle(
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'R\$ ${Moeda.ajustarMoeda(valor: movimentacao.valor.toDouble())}',
                  style: TextStyle(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
