import 'package:budgetopia/common/components/fields/info_fields.dart';
import 'package:budgetopia/ui/movimentacao/controller/movimentacao_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovimentacaoCampoParcelas extends StatelessWidget with DDIInject<MovimentacaoController> {
  MovimentacaoCampoParcelas({
    required this.valueController,
    required this.parcelasController,
    required this.parcelasFocusNode,
    required this.noteFocusNode,
    required this.primaryColor,
    required this.backgroundColor,
    super.key,
  });

  final TextEditingController valueController;
  final TextEditingController parcelasController;
  final FocusNode parcelasFocusNode;
  final FocusNode noteFocusNode;
  final Color primaryColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        InfoFields(
          label: 'Quantidade de Parcelas',
          icon: FontAwesomeIcons.listOl,
          controller: parcelasController,
          focusNode: parcelasFocusNode,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          nextFocus: noteFocusNode,
          onEditingComplete: noteFocusNode.requestFocus,
          validator: instance.validarQuantidadeParcelas,
          primaryColor: primaryColor,
          backgroundColor: backgroundColor,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: AnimatedBuilder(
            animation: Listenable.merge([valueController, parcelasController]),
            builder: (context, child) {
              final String valorTotal = instance.formatarValor(
                instance.calcularValorTotalParcelado(
                  valor: valueController.text,
                  parcelas: parcelasController.text,
                ),
              );
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Valor total: $valorTotal',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
