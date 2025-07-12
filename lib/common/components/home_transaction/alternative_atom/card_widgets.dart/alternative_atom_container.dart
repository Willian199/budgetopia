import 'package:budgetopia/common/components/generics/cache.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/card_widgets.dart/alternative_atom_category_badge.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/card_widgets.dart/alternative_atom_scanner_line.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/card_widgets.dart/alternative_atom_side_bar.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/card_widgets.dart/alternative_atom_status_indicator.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/card_widgets.dart/alternative_atom_value_display.dart';
import 'package:budgetopia/common/components/home_transaction/alternative_atom/card_widgets.dart/alternatve_atom_category_tag.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:flutter/material.dart';

class AlternativeAtomContainer extends StatefulWidget {
  const AlternativeAtomContainer({
    required this.transaction,
    required this.tipoMovimentacao,
    required this.isEntrada,
    required this.accentColor,
    required this.nomeCategoria,
    super.key,
  });

  final MovimentacaoModel transaction;
  final TipoMovimentacaoEnum? tipoMovimentacao;
  final bool isEntrada;
  final Color accentColor;
  final String nomeCategoria;

  @override
  State<AlternativeAtomContainer> createState() =>
      _AlternativeAtomContainerState();
}

class _AlternativeAtomContainerState extends State<AlternativeAtomContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.1,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main card - retro-futuristic console style
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Cache(
              value: (_pulseAnimation.value * 100).round() / 100,
              builder: (context, value) {
                return Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: AtomPunkColorPalette.darkGreen,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: widget.accentColor.withValues(alpha: (value)),
                        blurRadius: 10,
                        spreadRadius: -2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: widget.accentColor.withValues(
                        alpha: 0.2 + (value),
                      ),
                      width: 1.5,
                    ),
                  ),
                  child: child,
                );
              },
            );
          },
          child: Row(
            children: [
              // Side bar with atomic decoration
              AlternativeAtomSideBar(accentColor: widget.accentColor),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title and status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title in retro display style
                          Expanded(
                            child: Text(
                              widget.transaction.titulo.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: AtomPunkColorPalette.cream,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Status as light indicator
                          AlternativeAtomStatusIndicator(
                            isCompleted: widget.transaction.status,
                          ),
                        ],
                      ),

                      // Category with tag icon
                      AlternativeAtomCategoryTag(
                        nomeCategoria: widget.nomeCategoria,
                        accentColor: widget.accentColor,
                      ),

                      // Decorative scanner line
                      const AlternativeAtomScannerLine(),

                      // Value in atomic display style
                      AlternativeAtomValueDisplay(
                        value: widget.transaction.valor.toDouble(),
                        isEntrada: widget.isEntrada,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Category icon badge
        Positioned(
          top: -15,
          left: 10,
          child: AlternativeAtomCategoryBadge(
            tipoMovimentacao: widget.tipoMovimentacao,
            isEntrada: widget.isEntrada,
            accentColor: widget.accentColor,
          ),
        ),
      ],
    );
  }
}
