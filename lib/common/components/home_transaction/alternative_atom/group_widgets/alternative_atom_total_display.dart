import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/config/theme/home_color_template.dart';
import 'package:flutter/material.dart';

class AtompunkTotalDisplay extends StatelessWidget {
  const AtompunkTotalDisplay({required this.totalValue, super.key});

  final double totalValue;

  @override
  Widget build(BuildContext context) {
    final bool isPositive = totalValue >= 0;
    final Color valueColor = isPositive
        ? AtomPunkColorPalette.neonGreen
        : Colors.redAccent;
    final formattedValue = Moeda.format(valor: totalValue.abs());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AtomPunkColorPalette.darkGreen,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: valueColor.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: valueColor.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Direction symbol
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: valueColor.withValues(alpha: 0.5)),
            ),
            child: Center(
              child: Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                size: 10,
                color: valueColor,
              ),
            ),
          ),

          const SizedBox(width: 6),

          // Formatted value
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'BALANÇO ',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: AtomPunkColorPalette.cream.withValues(alpha: 0.6),
                    letterSpacing: 1,
                  ),
                ),
                TextSpan(
                  text: 'R\$$formattedValue',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
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
