import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubMenuBackButton extends StatelessWidget {
  const SubMenuBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Cores do tema
    final tertiaryColor = theme.colorScheme.tertiary;
    return Container(
      height: 40,
      width: 40,
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
      child: SizedBox(
        height: 30,
        width: 30,
        child: IconButton(
          style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.transparent),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.pop(context);
          },
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: theme.colorScheme.onTertiaryContainer,
            size: 20,
          ),
        ),
      ),
    );
  }
}
