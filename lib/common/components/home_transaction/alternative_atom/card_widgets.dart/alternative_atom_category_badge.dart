import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:flutter/material.dart';

class AlternativeAtomCategoryBadge extends StatelessWidget {
  const AlternativeAtomCategoryBadge({
    required this.tipoMovimentacao,
    required this.isEntrada,
    required this.accentColor,
    super.key,
  });

  final TipoMovimentacaoEnum? tipoMovimentacao;
  final bool isEntrada;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AtomPunkColorPalette.mainGreen,
        border: Border.all(color: accentColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: tipoMovimentacao != null
            ? Image.asset(
                'assets/icons/${tipoMovimentacao!.icone}',
                width: 18,
                height: 18,
                color: AtomPunkColorPalette.cream,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    isEntrada ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 15,
                    color: AtomPunkColorPalette.cream,
                  );
                },
              )
            : Icon(
                isEntrada ? Icons.arrow_upward : Icons.arrow_downward,
                size: 15,
                color: AtomPunkColorPalette.cream,
              ),
      ),
    );
  }
}
