import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:flutter/material.dart';

class HomeSegmentedButtonContent extends StatelessWidget {
  const HomeSegmentedButtonContent({
    required this.title,
    required this.value,
    required this.isSelected,
    super.key,
    this.showUpIcon,
  });
  final String title;
  final double value;
  final bool isSelected;
  final bool? showUpIcon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final color = isSelected ? Colors.white : colorScheme.primary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            letterSpacing: 0.5,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showUpIcon != null)
              Icon(
                showUpIcon! ? Icons.arrow_upward : Icons.arrow_downward,
                size: 10,
                color: color,
              ),
            Text(
              'R\$ ${Moeda.format(valor: value)}',
              style: TextStyle(
                fontSize: isSelected ? 15 : 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
