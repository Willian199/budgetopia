// File: alternative_atompunk_group.dart
import 'package:budgetopia/common/components/home_transaction/alternative_atom/alternative_atom_card.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/controller/alternative_atom_group_notifier.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/group_widgets/alternative_atom_connector.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/group_widgets/alternative_atom_control_panel.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:flutter/material.dart';

// Main widget
class AlternativeAtomGroup extends StatefulWidget {
  const AlternativeAtomGroup({
    required this.day,
    required this.month,
    required this.transactions,
    required this.isLast,
    this.onRefresh,
    super.key,
  });

  final int day;
  final String month;
  final List<MovimentacaoModel> transactions;
  final bool isLast;
  final VoidCallback? onRefresh;

  @override
  State<AlternativeAtomGroup> createState() => _AlternativeAtomGroupState();
}

class _AlternativeAtomGroupState extends State<AlternativeAtomGroup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AlternativeAtomGroupNotifier _notifier;

  late final double totalDiario;

  @override
  void initState() {
    super.initState();
    _notifier = AlternativeAtomGroupNotifier();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 1.0, // Start expanded
    );

    _notifier.addListener(_handleStateChange);

    totalDiario = _calculateDailyTotal();
  }

  void _handleStateChange() {
    if (_notifier.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _notifier.removeListener(_handleStateChange);
    _notifier.dispose();
    super.dispose();
  }

  double _calculateDailyTotal() {
    double total = 0;
    for (var transaction in widget.transactions) {
      if (transaction.tipoMovimentacao == 1) {
        // Income
        total += transaction.valor.toDouble();
      } else {
        // Expense
        total -= transaction.valor.toDouble();
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header control panel
        AlternativeAtomControlPanel(
          day: widget.day,
          month: widget.month,
          totalValue: totalDiario,
          transactionsCount: widget.transactions.length,
          notifier: _notifier,
        ),

        // Transactions list with animation
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return ClipRect(
              child: Align(heightFactor: _controller.value, child: child),
            );
          },
          child: Column(
            children: [
              const SizedBox(height: 20),
              ...widget.transactions.map((transaction) {
                return AlternativeAtomCard(
                  transaction: transaction,
                  onRefresh: widget.onRefresh,
                );
              }),

              // Connector to next group
              if (!widget.isLast && _notifier.isExpanded)
                const AlternativeAtomConnector(),
            ],
          ),
        ),

        // Space between groups
        SizedBox(height: _notifier.isExpanded ? 20 : 10),
      ],
    );
  }
}
