import 'package:budgetopia/common/components/button/default_menu_back_button.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class ContainerBackButton extends StatelessWidget {
  const ContainerBackButton({super.key});

  @override
  Widget build(BuildContext context) {

    final tertiaryColor = context.colorScheme.tertiary;
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: tertiaryColor.withAlpha(128),
        ),
        boxShadow: [
          BoxShadow(
            color: tertiaryColor.withAlpha(77),
            blurRadius: 8,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: tertiaryColor.withAlpha(100),
            blurRadius: 9,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: const DefaultMenuBackButton(),
    );
  }
}
