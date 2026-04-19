import 'package:budgetopia/common/components/home_transaction/cyberpunk_day_group.dart';
import 'package:budgetopia/common/extensions/datetime_extension.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/ui/home/controller/home_controller.dart';
import 'package:budgetopia/ui/home/view/widgets/home_transacion_empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeTransactionList extends StatefulWidget {
  const HomeTransactionList({
    required this.transacoes,
    this.onConfirmSuggestion,
    super.key,
  });
  final List<MovimentacaoModel> transacoes;
  final Future<bool> Function(MovimentacaoModel sugestao)? onConfirmSuggestion;

  @override
  State<HomeTransactionList> createState() => _HomeTransactionListState();
}

class _HomeTransactionListState extends State<HomeTransactionList> {
  late List<int> _diasOrdenados = [];
  final Map<int, List<MovimentacaoModel>> _transacoesPorDia = {};
  late final _controller = ddi.get<HomeController>();

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
    _transacoesPorDia.clear();
    _diasOrdenados.clear();

    for (var transacao in widget.transacoes) {
      final int dia = transacao.data.day;
      if (!_transacoesPorDia.containsKey(dia)) {
        _transacoesPorDia[dia] = [];
      }
      _transacoesPorDia[dia]!.add(transacao);
    }

    // Ordenar as chaves (dias) em ordem decrescente
    _diasOrdenados = _transacoesPorDia.keys.toList()..sort((a, b) => b.compareTo(a));
  }

  @override
  Widget build(BuildContext context) {
    if (_diasOrdenados.isEmpty) {
      return const HomeTransactionsEmpty();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _diasOrdenados.length,
        itemBuilder: (context, index) {
          final int dia = _diasOrdenados[index];
          final List<MovimentacaoModel> transacoesDoDia = _transacoesPorDia[dia]!;
          final String mes = transacoesDoDia.first.data.getFormattedMonth();

          return CyberpunkDayGroup(
            day: dia,
            month: mes,
            transactions: transacoesDoDia,
            isLast: index == _diasOrdenados.length - 1,
            onConfirmSuggestion: widget.onConfirmSuggestion,
            onRefresh: () {
              _controller.refresh(_controller.value.tabSelecionada);
            },
          );
        },
      ),
    );
  }
}
