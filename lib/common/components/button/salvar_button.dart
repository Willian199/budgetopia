import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SalvarButton extends StatelessWidget {
  const SalvarButton({
    this.height = 50,
    this.width = 50,
    this.onPressed,
    super.key,
  });
  final double height;
  final double width;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Cores do tema
    final primaryColor = theme.colorScheme.primary;
    final tertiaryColor = theme.colorScheme.tertiary;

    return Container(
      height: height,
      width: width,
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
      child: IconButton(
        icon: FaIcon(
          FontAwesomeIcons.floppyDisk,
          color: primaryColor,
          size: 20,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
