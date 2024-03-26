import 'package:budgetopia/common/enum/tipo_registro_enum.dart';
import 'package:budgetopia/pages/home/view/home_page.dart';
import 'package:flutter/material.dart';

mixin HomeMixin on State<HomePage> {
  final TextEditingController _pesquisaController = TextEditingController();
  final FocusNode _pesquisaFocus = FocusNode();

  final ScrollController scrollMovimentacaoController = ScrollController();

  final String imageUrl = 'https://cdn-icons-png.flaticon.com/512/6073/6073874.png';
  int notificationCount = 1;

  @override
  void dispose() {
    _pesquisaController.dispose();
    _pesquisaFocus.dispose();
    super.dispose();
  }

  ButtonSegment<TipoRegistroEnum> makeSegmentedButton(TipoRegistroEnum tipo, Set<TipoRegistroEnum>? tabSelecionada, ColorScheme colorScheme) {
    tabSelecionada ??= {TipoRegistroEnum.todos};
    return ButtonSegment<TipoRegistroEnum>(
      value: tipo,
      label: Text(
        tipo.nome,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: tipo.posicao == tabSelecionada.first.posicao ? colorScheme.onPrimary : colorScheme.onTertiaryContainer,
        ),
      ),
    );
  }
}
