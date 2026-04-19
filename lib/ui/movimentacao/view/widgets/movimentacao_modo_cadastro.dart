import 'package:budgetopia/common/components/fields/info_fields.dart';
import 'package:budgetopia/common/components/input_formatters/decimal_input_formatter.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:budgetopia/common/enum/tipo_recorrencia_enum.dart';
import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
import 'package:budgetopia/ui/movimentacao/enum/tipo_cadastro_movimentacao_enum.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/data_fim_recorrencia.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/data_movimentacao.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/modo_cadastro_movimentacao.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/movimentacao_campo_parcelas.dart';
import 'package:budgetopia/ui/movimentacao/view/widgets/tipo_recorrencia.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovimentacaoModoCadastro extends StatelessWidget with DDIInject<MovimentacaoController> {
  MovimentacaoModoCadastro({
    required this.isEdicaoRecorrencia,
    required this.possuiMovimentacao,
    required this.valueController,
    required this.parcelasController,
    required this.intervaloRecorrenciaController,
    required this.tipoRecorrenciaFocusNode,
    required this.dateFocusNode,
    required this.dataFimRecorrenciaFocusNode,
    required this.valueFocusNode,
    required this.parcelasFocusNode,
    required this.intervaloRecorrenciaFocusNode,
    required this.noteFocusNode,
    required this.primaryColor,
    required this.backgroundColor,
    super.key,
  });

  final bool isEdicaoRecorrencia;
  final bool possuiMovimentacao;
  final TextEditingController valueController;
  final TextEditingController parcelasController;
  final TextEditingController intervaloRecorrenciaController;
  final FocusNode tipoRecorrenciaFocusNode;
  final FocusNode dateFocusNode;
  final FocusNode dataFimRecorrenciaFocusNode;
  final FocusNode valueFocusNode;
  final FocusNode parcelasFocusNode;
  final FocusNode intervaloRecorrenciaFocusNode;
  final FocusNode noteFocusNode;
  final Color primaryColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TipoCadastroMovimentacaoEnum>(
      valueListenable: instance.tipoCadastro,
      builder: (context, tipoCadastro, child) {
        final bool exibirModoCadastro = !possuiMovimentacao && !isEdicaoRecorrencia;
        final bool exibirCamposRecorrencia =
            !possuiMovimentacao && (isEdicaoRecorrencia || tipoCadastro == TipoCadastroMovimentacaoEnum.recorrencia);
        final bool isParcelado =
            !isEdicaoRecorrencia && !possuiMovimentacao && tipoCadastro == TipoCadastroMovimentacaoEnum.parcelado;

        return Column(
          spacing: 15,
          children: [
            if (exibirModoCadastro) const ModoCadastroMovimentacao(),
            if (exibirCamposRecorrencia)
              ValueListenableBuilder<TipoRecorrenciaEnum>(
                valueListenable: instance.tipoRecorrencia,
                builder: (context, tipoRecorrencia, child) {
                  return Column(
                    spacing: 15,
                    children: [
                      TipoRecorrencia(
                        focusNode: tipoRecorrenciaFocusNode,
                        nextFocusNode: tipoRecorrencia.usaIntervaloDias ? intervaloRecorrenciaFocusNode : dateFocusNode,
                      ),
                      if (tipoRecorrencia.usaIntervaloDias)
                        InfoFields(
                          label: Strings.INTERVALO_EM_DIAS,
                          icon: FontAwesomeIcons.clockRotateLeft,
                          controller: intervaloRecorrenciaController,
                          focusNode: intervaloRecorrenciaFocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          nextFocus: dateFocusNode,
                          validator: instance.validarIntervaloRecorrencia,
                          primaryColor: primaryColor,
                          backgroundColor: backgroundColor,
                        ),
                    ],
                  );
                },
              ),
            Column(
              spacing: 15,
              children: [
                DataMovimentacao(
                  focusNode: dateFocusNode,
                  nextFocus: exibirCamposRecorrencia ? dataFimRecorrenciaFocusNode : valueFocusNode,
                ),
                if (exibirCamposRecorrencia)
                  DataFimRecorrencia(
                    focusNode: dataFimRecorrenciaFocusNode,
                    nextFocus: valueFocusNode,
                  ),
              ],
            ),
            InfoFields(
              label: Strings.VALOR,
              icon: FontAwesomeIcons.moneyBill1Wave,
              controller: valueController,
              focusNode: valueFocusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                DecimalInputFormatter(allowNegative: false),
              ],
              nextFocus: isParcelado ? parcelasFocusNode : noteFocusNode,
              onTap: () {
                if (valueFocusNode.hasPrimaryFocus) {
                  return;
                }

                valueController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: valueController.value.text.length,
                );
              },
              validator: instance.validarValor,
              primaryColor: primaryColor,
              backgroundColor: backgroundColor,
            ),
            if (isParcelado)
              MovimentacaoCampoParcelas(
                valueController: valueController,
                parcelasController: parcelasController,
                parcelasFocusNode: parcelasFocusNode,
                noteFocusNode: noteFocusNode,
                primaryColor: primaryColor,
                backgroundColor: backgroundColor,
              ),
          ],
        );
      },
    );
  }
}
