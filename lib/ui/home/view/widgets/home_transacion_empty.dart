import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeTransactionsEmpty extends StatelessWidget {
  const HomeTransactionsEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.fileCircleExclamation,
            size: 48,
            color: theme.colorScheme.primary.withAlpha(150),
          ),
          const SizedBox(height: 16),
          Text(
            Strings.NENHUMA_TRANSACAO_ENCONTRADA,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
