import 'package:budgetopia/common/components/home_transaction/alternative_atom/alternative_atom_group.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/ui/home/controller/home_controller.dart';
import 'package:budgetopia/ui/home/view/widgets/home_transacion_empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeTransactionList extends StatefulWidget {
  const HomeTransactionList({required this.transacoes, super.key});
  final List<MovimentacaoModel> transacoes;

  @override
  State<HomeTransactionList> createState() => _HomeTransactionListState();
}

class _HomeTransactionListState extends State<HomeTransactionList> {
  late List<int> diasOrdenados = [];
  final Map<int, List<MovimentacaoModel>> transacoesPorDia = {};
  late final controller = ddi.get<HomeController>();

  @override
  void didUpdateWidget(covariant HomeTransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);

    _refresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh();
  }

  void _refresh() {
    transacoesPorDia.clear();
    diasOrdenados.clear();

    for (var transacao in widget.transacoes) {
      final int dia = transacao.data.day;
      if (!transacoesPorDia.containsKey(dia)) {
        transacoesPorDia[dia] = [];
      }
      transacoesPorDia[dia]!.add(transacao);
    }

    // Ordenar as chaves (dias) em ordem decrescente
    diasOrdenados = transacoesPorDia.keys.toList()..sort((a, b) => b.compareTo(a));
  }

  @override
  Widget build(BuildContext context) {
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

          return AlternativeAtomGroup(
            day: dia,
            month: mes,
            transactions: transacoesDoDia,
            isLast: index == diasOrdenados.length - 1,
            onRefresh: () {
              controller.refresh(controller.value.tabSelecionada);
            },
          );
        },
      ),
    );
  }
}
