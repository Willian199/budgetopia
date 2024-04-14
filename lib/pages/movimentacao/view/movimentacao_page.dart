import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:budgetopia/common/components/generics/custom_snackbar.dart';
import 'package:budgetopia/common/components/generics/degrade.dart';
import 'package:budgetopia/common/components/input_formatters/decimal_input_formatter.dart';
import 'package:budgetopia/common/enum/categoria_enum.dart';
import 'package:budgetopia/common/enum/tipo_movimentacao_enum.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:budgetopia/common/utils/moeda.dart';
import 'package:budgetopia/pages/movimentacao/controller/categoria_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/data_movimentacao_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/movimentacao_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/status_pagamento_controller.dart';
import 'package:budgetopia/pages/movimentacao/controller/tipo_movimentacao_controller.dart';
import 'package:budgetopia/pages/movimentacao/mixin/movimentacao_page_mixin.dart';
import 'package:budgetopia/pages/movimentacao/model/movimentacao_model.dart';
import 'package:budgetopia/pages/movimentacao/widgets/data_movimentacao.dart';
import 'package:budgetopia/pages/movimentacao/widgets/selecionar_categoria.dart';
import 'package:budgetopia/pages/movimentacao/widgets/status_pagamento.dart';
import 'package:budgetopia/pages/movimentacao/widgets/tipo_movimentacao.dart';
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
      Future.delayed(Duration.zero, () {
        ddi.get<DataMovimentacaoController>().alterarDataMovimentacao(widget.movimentacaoModel!.data);
        ddi.get<CategoriaController>().selecionarCategoria(CategoriaEnum.getById(widget.movimentacaoModel!.codigoCategoria));
        ddi.get<TipoMovimentacaoController>().selecionarTipoMovimentacao(TipoMovimentacaoEnum.getById(widget.movimentacaoModel!.tipoMovimentacao));
        ddi.get<StatusPagamentoController>().alterarStatus(widget.movimentacaoModel?.status ?? false);
      });
    } else {
      valueController.text = Moeda.format(valor: 0, simbolo: 'R\$', decimalDigits: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = AdaptiveTheme.of(context).theme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimentação'),
        actions: [
          if (widget.movimentacaoModel != null)
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.trash,
                color: Colors.redAccent,
              ),
              onPressed: () {
                final MovimentacaoController controller = ddi.get<MovimentacaoController>();
                if (controller.remover(widget.movimentacaoModel!.id)) {
                  Navigator.pop(context);

                  CustomSnackBar.sucesso(mensagem: 'Transação removida');
                } else {
                  CustomSnackBar.informacacao(mensagem: 'Erro ao remover transação');
                }
              },
            ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.floppyDisk,
              color: tema.colorScheme.primary,
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                context.closeKeyboard();

                final MovimentacaoController salvar = ddi.get<MovimentacaoController>();

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
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(10),
        decoration: Degrade.efeitoDegrade(
          cores: <Color>[
            tema.colorScheme.primaryContainer,
            tema.colorScheme.onSecondary,
          ],
        ),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  controller: titleController,
                  focusNode: titleFocusNode,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    prefixIcon: SizedBox(
                      width: 40,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: FaIcon(
                            FontAwesomeIcons.noteSticky,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(categoryFocusNode);
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? false) {
                      return 'Por favor, insira um título';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 15.0),
              SelecionarCategoria(focusNode: categoryFocusNode),
              const SizedBox(height: 15.0),
              TipoMovimentacao(focusNode: transactionTypeFocusNode),
              const SizedBox(height: 15.0),
              DataMovimentacao(focusNode: dateFocusNode),
              const SizedBox(height: 15.0),
              TextFormField(
                controller: valueController,
                focusNode: valueFocusNode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  prefixIcon: SizedBox(
                    width: 40,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: FaIcon(
                          FontAwesomeIcons.moneyBill1Wave,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  DecimalInputFormatter(allowNegative: false),
                ],
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(noteFocusNode);
                },
                validator: (value) {
                  if (value?.isEmpty ?? false) {
                    return 'Por favor, insira um valor';
                  }
                  return null;
                },
              ),
              const StatusPagamento(),
              TextFormField(
                controller: noteController,
                focusNode: noteFocusNode,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
