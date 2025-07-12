// File: alternative_atompunk_card.dart

import 'package:budgetopia/common/components/home_transaction/alternative_atom/card_widgets.dart/alternative_atom_container.dart';
import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:budgetopia/ui/movimentacao/module/movimentacao_module.dart';
import 'package:budgetopia/ui/movimentacao/view/movimentacao_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

// Main widget
class AlternativeAtomCard extends StatefulWidget {
  const AlternativeAtomCard({
    required this.transaction,
    this.onRefresh,
    super.key,
  });

  final MovimentacaoModel transaction;
  final VoidCallback? onRefresh;

  @override
  State<AlternativeAtomCard> createState() => _AlternativeAtomCardState();
}

class _AlternativeAtomCardState extends State<AlternativeAtomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEntrada = widget.transaction.tipoMovimentacao == 1;
    final tipoMovimentacao = TipoMovimentacaoEnum.getById(
      widget.transaction.tipoMovimentacao,
    );
    final nomeCategoria =
        CategoriaEnum.getById(widget.transaction.codigoCategoria)?.nome ?? '';
    final Color accentColor = isEntrada
        ? AtomPunkColorPalette.neonGreen
        : Colors.redAccent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTapDown: (_) {
          _controller.forward();
        },
        onTapUp: (_) {
          _controller.reverse();
        },
        onTapCancel: () {
          _controller.reverse();
        },
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FlutterDDIBuilder(
                module: MovimentacaoModule.new,
                child: (_) =>
                    MovimentacaoPage(movimentacaoModel: widget.transaction),
              ),
            ),
          );

          if (widget.onRefresh != null) {
            widget.onRefresh!();
          }
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AlternativeAtomContainer(
                transaction: widget.transaction,
                tipoMovimentacao: tipoMovimentacao,
                isEntrada: isEntrada,
                accentColor: accentColor,
                nomeCategoria: nomeCategoria,
              ),
            );
          },
        ),
      ),
    );
  }
}
