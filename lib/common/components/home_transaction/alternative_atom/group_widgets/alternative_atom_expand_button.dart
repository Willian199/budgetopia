import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AlternativeAtomExpandButton extends StatelessWidget {
  const AlternativeAtomExpandButton({
    required this.isExpanded,
    super.key,
  });

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Container(
      width: 30,
      height: 80,
      decoration: const BoxDecoration(
        //Color(0xFF009969)
        color: Color(0xFF009969),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Center(
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.onPrimaryFixedVariant,
            ),
          ),
          child: Center(
            child: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 14,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
