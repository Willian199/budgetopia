import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/ui/movimentacao/view/movimentacao_page.dart';
import 'package:flutter/material.dart';

mixin MovimentacaoPageMixin on State<MovimentacaoPage> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final valueController = TextEditingController();
  final noteController = TextEditingController();
  final parcelasController = TextEditingController(text: Strings.QUANTIDADE_PARCELAS_PADRAO);
  final intervaloRecorrenciaController = TextEditingController(text: Strings.INTERVALO_RECORRENCIA_PADRAO);

  final titleFocusNode = FocusNode();
  final categoriaFocusNode = FocusNode();
  final tipoMovimentacaoFocusNode = FocusNode();
  final tipoRecorrenciaFocusNode = FocusNode();
  final dateFocusNode = FocusNode();
  final dataFimRecorrenciaFocusNode = FocusNode();
  final valueFocusNode = FocusNode();
  final parcelasFocusNode = FocusNode();
  final intervaloRecorrenciaFocusNode = FocusNode();
  final noteFocusNode = FocusNode();

  @override
  void dispose() {
    titleController.dispose();
    valueController.dispose();
    noteController.dispose();
    parcelasController.dispose();
    intervaloRecorrenciaController.dispose();
    titleFocusNode.dispose();
    categoriaFocusNode.dispose();
    tipoMovimentacaoFocusNode.dispose();
    tipoRecorrenciaFocusNode.dispose();
    dateFocusNode.dispose();
    dataFimRecorrenciaFocusNode.dispose();
    valueFocusNode.dispose();
    parcelasFocusNode.dispose();
    intervaloRecorrenciaFocusNode.dispose();
    noteFocusNode.dispose();
    super.dispose();
  }
}
