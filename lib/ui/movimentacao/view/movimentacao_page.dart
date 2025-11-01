import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/button/salvar_button.dart';
import 'package:budgetopia/common/components/button/sub_menu_back_button.dart';
import 'package:budgetopia/common/components/generics/app_scaffold.dart';
import 'package:budgetopia/common/components/generics/custom_snackbar.dart';
import 'package:budgetopia/common/components/input_formatters/decimal_input_formatter.dart';

import 'package:budgetopia/common/components/generics/page_title.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/config/model/movimentacao_model.dart';
import 'package:budgetopia/ui/movimentacao/case/movimentacao_case.dart';
import 'package:budgetopia/ui/movimentacao/controller/categoria_controller.dart';
import 'package:budgetopia/ui/movimentacao/controller/data_movimentacao_controller.dart';
import 'package:budgetopia/ui/movimentacao/controller/status_pagamento_controller.dart';
import 'package:budgetopia/ui/movimentacao/controller/tipo_movimentacao_controller.dart';
import 'package:budgetopia/ui/movimentacao/mixin/movimentacao_page_mixin.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/data_movimentacao.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/selecionar_categoria.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/status_pagamento.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/tipo_movimentacao.dart';
import 'package:budgetopia/common/components/fields/info_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovimentacaoPage extends StatefulWidget {
  const MovimentacaoPage({this.movimentacaoModel, super.key});

  final MovimentacaoModel? movimentacaoModel;
  @override
  _MovimentacaoPageState createState() => _MovimentacaoPageState();
}

class _MovimentacaoPageState extends State<MovimentacaoPage> with MovimentacaoPageMixin {
  @override
  void initState() {
    super.initState();

    if (widget.movimentacaoModel != null) {
      titleController.text = widget.movimentacaoModel!.titulo;
      valueController.text = Moeda.format(valor: widget.movimentacaoModel!.valor, simbolo: 'R\$', decimalDigits: 2);
      noteController.text = widget.movimentacaoModel!.observacao ?? '';
      ddi.get<DataMovimentacaoController>().alterarDataMovimentacao(widget.movimentacaoModel!.data);
      ddi.get<CategoriaController>().selecionarCategoria(
        CategoriaEnum.getById(widget.movimentacaoModel!.codigoCategoria),
      );
      ddi.get<TipoMovimentacaoController>().selecionarTipoMovimentacao(
        TipoMovimentacaoEnum.getById(widget.movimentacaoModel!.tipoMovimentacao),
      );
      ddi.get<StatusPagamentoController>().alterarStatus(widget.movimentacaoModel?.status ?? false);
    } else {
      valueController.text = Moeda.format(valor: 0, simbolo: 'R\$', decimalDigits: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AdaptiveTheme.of(context).theme;

    // Cores do tema
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;
    final backgroundColor = theme.colorScheme.surface;

    return AppScaffold(
      appBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botão de voltar
          const SubMenuBackButton(),

          // Título
          const PageTitle(title: Strings.MOVIMENTACAO),

          // Botão de Excluir
          if (widget.movimentacaoModel != null)
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
                icon: const FaIcon(
                  FontAwesomeIcons.trash,
                  color: Colors.redAccent,
                  size: 20,
                ),
                onPressed: () {
                  final MovimentacaoCase controller = ddi.get();
                  if (controller.remover(widget.movimentacaoModel!.id)) {
                    Navigator.pop(context);

                    CustomSnackBar.sucesso(mensagem: 'Transação removida');
                  } else {
                    CustomSnackBar.informacacao(mensagem: 'Erro ao remover transação');
                  }
                },
              ),
            ),

          SalvarButton(
            height: 40,
            width: 40,
            onPressed: () {
              final double valor = Moeda.parse(valor: valueController.text, simbolo: 'R\$').toDouble();
              if ((formKey.currentState?.validate() ?? false) && valor > 0) {
                context.closeKeyboard();

                final MovimentacaoCase salvar = ddi.get();

                final bool status = salvar.salvar(
                  id: widget.movimentacaoModel?.id ?? 0,
                  titulo: titleController.text.trim(),
                  valor: Moeda.parse(valor: valueController.text, simbolo: 'R\$').toDouble(),
                  observacao: noteController.text.trim(),
                );

                if (!status) {
                  return;
                }

                Navigator.pop(context);

                CustomSnackBar.sucesso(mensagem: 'Transação salva!');
              } else {
                CustomSnackBar.informacacao(mensagem: 'Verifique os dados informados!');
              }
            },
          ),
        ],
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: <Widget>[
            // Campo Nome
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: InfoFields(
                label: Strings.TITULO,
                icon: FontAwesomeIcons.noteSticky,
                controller: titleController,
                focusNode: titleFocusNode,
                nextFocus: categoriaFocusNode,
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
                primaryColor: primaryColor,
                backgroundColor: backgroundColor,
              ),
            ),
            const SizedBox(height: 15.0),
            SelecionarCategoria(
              focusNode: categoriaFocusNode,
              nextFocusNode: tipoMovimentacaoFocusNode,
            ),
            const SizedBox(height: 15.0),
            TipoMovimentacao(
              focusNode: tipoMovimentacaoFocusNode,
              nextFocusNode: dateFocusNode,
            ),
            const SizedBox(height: 15.0),
            DataMovimentacao(
              focusNode: dateFocusNode,
              nextFocus: valueFocusNode,
            ),
            const SizedBox(height: 15.0),
            InfoFields(
              label: Strings.VALOR,
              icon: FontAwesomeIcons.moneyBill1Wave,
              controller: valueController,
              focusNode: valueFocusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                DecimalInputFormatter(allowNegative: false),
              ],
              nextFocus: noteFocusNode,
              onTap: () {
                if (!valueFocusNode.hasPrimaryFocus) {
                  valueController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: valueController.value.text.length,
                  );
                }
              },
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return Strings.INFORME_VALOR;
                }
                return null;
              },

              primaryColor: primaryColor,
              backgroundColor: backgroundColor,
            ),

            const StatusPagamento(),
            TextFormField(
              controller: noteController,
              focusNode: noteFocusNode,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observações',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
