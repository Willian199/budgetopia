import 'package:budgetopia/common/components/fields/info_fields.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/movimentacao_modo_cadastro.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/selecionar_categoria.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/status_pagamento.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/tipo_movimentacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovimentacaoFormulario extends StatelessWidget with DDIInject<MovimentacaoController> {
  MovimentacaoFormulario({
    required this.formKey,
    required this.isEdicaoRecorrencia,
    required this.possuiMovimentacao,
    required this.titleController,
    required this.valueController,
    required this.noteController,
    required this.parcelasController,
    required this.intervaloRecorrenciaController,
    required this.titleFocusNode,
    required this.categoriaFocusNode,
    required this.tipoMovimentacaoFocusNode,
    required this.tipoRecorrenciaFocusNode,
    required this.dateFocusNode,
    required this.dataFimRecorrenciaFocusNode,
    required this.valueFocusNode,
    required this.parcelasFocusNode,
    required this.intervaloRecorrenciaFocusNode,
    required this.noteFocusNode,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final bool isEdicaoRecorrencia;
  final bool possuiMovimentacao;
  final TextEditingController titleController;
  final TextEditingController valueController;
  final TextEditingController noteController;
  final TextEditingController parcelasController;
  final TextEditingController intervaloRecorrenciaController;
  final FocusNode titleFocusNode;
  final FocusNode categoriaFocusNode;
  final FocusNode tipoMovimentacaoFocusNode;
  final FocusNode tipoRecorrenciaFocusNode;
  final FocusNode dateFocusNode;
  final FocusNode dataFimRecorrenciaFocusNode;
  final FocusNode valueFocusNode;
  final FocusNode parcelasFocusNode;
  final FocusNode intervaloRecorrenciaFocusNode;
  final FocusNode noteFocusNode;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;
    final backgroundColor = theme.colorScheme.surface;

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        spacing: 15,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: InfoFields(
              label: Strings.TITULO,
              icon: FontAwesomeIcons.noteSticky,
              controller: titleController,
              focusNode: titleFocusNode,
              nextFocus: categoriaFocusNode,
              validator: instance.validarTitulo,
              primaryColor: primaryColor,
              backgroundColor: backgroundColor,
            ),
          ),
          SelecionarCategoria(
            focusNode: categoriaFocusNode,
            nextFocusNode: tipoMovimentacaoFocusNode,
          ),
          TipoMovimentacao(
            focusNode: tipoMovimentacaoFocusNode,
            nextFocusNode: dateFocusNode,
          ),
          MovimentacaoModoCadastro(
            isEdicaoRecorrencia: isEdicaoRecorrencia,
            possuiMovimentacao: possuiMovimentacao,
            valueController: valueController,
            parcelasController: parcelasController,
            intervaloRecorrenciaController: intervaloRecorrenciaController,
            tipoRecorrenciaFocusNode: tipoRecorrenciaFocusNode,
            dateFocusNode: dateFocusNode,
            dataFimRecorrenciaFocusNode: dataFimRecorrenciaFocusNode,
            valueFocusNode: valueFocusNode,
            parcelasFocusNode: parcelasFocusNode,
            intervaloRecorrenciaFocusNode: intervaloRecorrenciaFocusNode,
            noteFocusNode: noteFocusNode,
            primaryColor: primaryColor,
            backgroundColor: backgroundColor,
          ),
          const StatusPagamento(),
          InfoFields(
            label: Strings.OBSERVACOES,
            icon: FontAwesomeIcons.info,
            controller: noteController,
            focusNode: noteFocusNode,
            keyboardType: TextInputType.multiline,
            validator: (_) => null,
            primaryColor: primaryColor,
            backgroundColor: backgroundColor,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
