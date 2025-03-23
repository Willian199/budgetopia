import 'package:budgetopia/common/components/home_transaction/alternative_atom/alternative_atom_group.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:flutter/material.dart';

class AlternativeAtomValueDisplay extends StatelessWidget {
  const AlternativeAtomValueDisplay({
    required this.value,
    required this.isEntrada,
    super.key,
  });

  final double value;
  final bool isEntrada;

  @override
  Widget build(BuildContext context) {
    final formattedValue = Moeda.format(valor: value);
    final Color indicatorColor = isEntrada ? AtomPunkColorPalette.neonGreen : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AtomPunkColorPalette.mainGreen,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AtomPunkColorPalette.cream.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isEntrada ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: indicatorColor,
          ),
          const SizedBox(width: 5),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'R\$ ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AtomPunkColorPalette.cream.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                TextSpan(
                  text: formattedValue,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AtomPunkColorPalette.cream,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
