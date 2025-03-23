import 'package:budgetopia/common/components/home_transaction/alternative_atom/alternative_atom_group.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/ui/home/controller/home_controller.dart';
import 'package:budgetopia/ui/home/view/widgets/home_transacion_empty.dart';
import 'package:flutter/material.dart';

class HomeTransactionList extends StatelessWidget {
  const HomeTransactionList({
    required this.listenable,
    super.key,
  });
  final HomeController listenable;

  @override
  Widget build(BuildContext context) {
    // Obter as transações agrupadas por dia
    final List<MovimentacaoModel> transacoes = listenable.registrosAbaMovimentacao;

    // Agrupar por dia
    final Map<int, List<MovimentacaoModel>> transacoesPorDia = {};

    for (var transacao in transacoes) {
      final int dia = transacao.data.day;
      if (!transacoesPorDia.containsKey(dia)) {
        transacoesPorDia[dia] = [];
      }
      transacoesPorDia[dia]!.add(transacao);
    }

    // Ordenar as chaves (dias) em ordem decrescente
    final List<int> diasOrdenados = transacoesPorDia.keys.toList()..sort((a, b) => b.compareTo(a));

    if (diasOrdenados.isEmpty) {
      return const HomeTransactionsEmpty();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: diasOrdenados.length,
        itemBuilder: (context, index) {
          final int dia = diasOrdenados[index];
          final List<MovimentacaoModel> transacoesDoDia = transacoesPorDia[dia]!;
          final String mes = transacoesDoDia.first.data.getFormattedMonth();

          return AlternativeAtomGroup(
            day: dia,
            month: mes,
            transactions: transacoesDoDia,
            isLast: index == diasOrdenados.length - 1,
            onRefresh: () => listenable.refresh(listenable.value.tabSelecionada),
          );
        },
      ),
    );
  }
}
