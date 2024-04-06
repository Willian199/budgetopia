import 'package:budgetopia/common/utils/moeda.dart';
import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({this.simbolo = 'R\$', this.decimalDigits = 2});

  final String simbolo;
  final int decimalDigits;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove todos os caracteres não numéricos

    String newText = newValue.text.replaceAll(simbolo, '').replaceAll(RegExp(r'[^0-9,.]'), '').trim();

    final double valor = Moeda.parse(valor: newText, decimalDigits: decimalDigits).toDouble();
    newText = Moeda.format(valor: valor, simbolo: simbolo, decimalDigits: decimalDigits);

    int pos = newValue.selection.baseOffset;

    if (newValue.text.length != newText.length) {
      if (newValue.text.length > newText.length) {
        // Caractere removido
        // Se o caractere removido foi o ponto decimal, ajusta o cursor
        if (newValue.text[pos - 1] == '.') {
          pos += 1;
        }
      } else {
        // Caractere adicionado
        // Se o caractere adicionado foi o ponto decimal, ajusta o cursor
        if (newValue.text.length <= pos) {
          pos = newValue.text.length;
        } else if (newValue.text[pos] == '.') {
          pos -= 1;
        }
      }
    }

    // Retorna o novo valor formatado
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: pos.clamp(0, newText.length)),
    );
  }
}
