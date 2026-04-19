import 'package:budgetopia/common/components/home_transaction/cyberpunk_day_group.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/ui/home/view/widgets/home_transacion_empty.dart';
import 'package:flutter/material.dart';

class HomeTransactionList extends StatelessWidget {
  const HomeTransactionList({
    required this.transacoes,
    this.onConfirmSuggestion,
    this.onRefresh,
    super.key,
  });

  final List<MovimentacaoModel> transacoes;
  final Future<bool> Function(MovimentacaoModel sugestao)? onConfirmSuggestion;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final Map<int, List<MovimentacaoModel>> transacoesPorDia = _agruparTransacoesPorDia();
    final List<int> diasOrdenados = transacoesPorDia.keys.toList()..sort((a, b) => b.compareTo(a));

    if (diasOrdenados.isEmpty) {
      return const HomeTransactionsEmpty();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: diasOrdenados.length,
        itemBuilder: (context, index) {
          final int dia = diasOrdenados[index];
          final List<MovimentacaoModel> transacoesDoDia = transacoesPorDia[dia]!;
          final String mes = transacoesDoDia.first.data.getFormattedMonth();

          return CyberpunkDayGroup(
            day: dia,
            month: mes,
            transactions: transacoesDoDia,
            isLast: index == diasOrdenados.length - 1,
            onConfirmSuggestion: onConfirmSuggestion,
            onRefresh: onRefresh,
          );
        },
      ),
    );
  }

  Map<int, List<MovimentacaoModel>> _agruparTransacoesPorDia() {
    final Map<int, List<MovimentacaoModel>> transacoesPorDia = {};

    for (final MovimentacaoModel transacao in transacoes) {
      final int dia = transacao.data.day;
      transacoesPorDia.putIfAbsent(dia, () => []).add(transacao);
    }

    return transacoesPorDia;
  }
}
