import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AlternativeAtomCategoryTag extends StatelessWidget {
  const AlternativeAtomCategoryTag({
    required this.nomeCategoria,
    required this.accentColor,
    super.key,
  });

  final String nomeCategoria;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.tag,
          size: 8,
          color: accentColor.withValues(alpha: 0.8),
        ),
        const SizedBox(width: 5),
        Text(
          nomeCategoria.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            color: accentColor.withValues(alpha: 0.8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
