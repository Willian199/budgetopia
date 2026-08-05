import 'package:budgetopia/common/components/button/salvar_button.dart';
import 'package:budgetopia/common/components/button/sub_menu_back_button.dart';
import 'package:budgetopia/common/components/generics/page_title.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovimentacaoAppBar extends StatelessWidget {
  const MovimentacaoAppBar({
    required this.exibirRemover,
    required this.onSalvar,
    required this.onRemover,
    super.key,
  });

  final bool exibirRemover;
  final VoidCallback onSalvar;
  final VoidCallback onRemover;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final errorColor = theme.colorScheme.error;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SubMenuBackButton(),
        const PageTitle(title: Strings.MOVIMENTACAO),
        if (exibirRemover)
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: errorColor.withAlpha(128),
              ),
              boxShadow: [
                BoxShadow(
                  color: errorColor.withAlpha(77),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: errorColor.withAlpha(100),
                  blurRadius: 9,
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.trashCan,
                color: errorColor,
                size: 20,
              ),
              onPressed: onRemover,
            ),
          ),
        SalvarButton(
          height: 40,
          width: 40,
          onPressed: onSalvar,
        ),
      ],
    );
  }
}
