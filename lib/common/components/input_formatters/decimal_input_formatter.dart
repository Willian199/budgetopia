import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DecimalInputFormatter extends TextInputFormatter {
  DecimalInputFormatter({
    this.decimalPlaces = 2,
    this.allowNegative = true,
    this.symbol = 'R\$',
    this.allowSymbolAtStart = true,
  }) : _numberFormat = NumberFormat.currency(
          locale: 'pt_BR',
          symbol: symbol,
          decimalDigits: decimalPlaces,
        );

  final int decimalPlaces;
  final bool allowNegative;
  final String symbol;
  final bool allowSymbolAtStart;
  final NumberFormat _numberFormat;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.contains(",") && !newValue.text.contains(",")) {
      return TextEditingValue(
        text: oldValue.text,
        selection: TextSelection.collapsed(offset: oldValue.selection.baseOffset - 1),
      );
    }

    String value = newValue.text.replaceAll(RegExp(r'(,)+'), ',');

    // If it starts with the specified symbol and symbols are allowed at the start, allow it
    final bool containsSymbol = _startsWithSymbol(value);

    // If it contains a "-" and negative numbers are allowed, allow it
    final bool negate = _startsWithNegativeSign(value);
    if (allowNegative && negate) {
      value = '-${value.replaceAll('-', '').trim()}';
    }

    // Remove any non-digit characters except decimal separator and comma
    value = _getDigitsOnly(value);

    // If there are no digits left, return empty
    if (value.isEmpty) {
      return TextEditingValue.empty;
    }

    // Convert commas to dots for the decimal separator
    value = value.replaceAll(',', '.');

    // If there is a decimal point, limit the decimal places
    if (decimalPlaces > 0) {
      final List<String> parts = value.split('.');
      if (parts.length > 1) {
        final String decimalPart = parts[1].padRight(decimalPlaces, '0').substring(0, decimalPlaces);
        value = '${parts[0]}.$decimalPart';
      }
    }

    // Parse the value to a double
    final double parsedValue = double.tryParse(value) ?? 0.0;

    // Convert the value back to cents for proper formatting
    final int valueInCents = (parsedValue * 100).round();

    // Format the value back to currency string
    final String formattedValue = _numberFormat.format(valueInCents / 100);

    // Calculate the new cursor position
    int cursorPosition = newValue.selection.baseOffset - (newValue.text.length - formattedValue.length).clamp(0, formattedValue.length);

    // Ensure the new cursor position is within bounds
    if (containsSymbol && !negate && cursorPosition <= _numberFormat.positivePrefix.length) {
      cursorPosition = cursorPosition.clamp(_numberFormat.positivePrefix.length + 1, formattedValue.length);
    } else if (containsSymbol && negate && cursorPosition <= _numberFormat.negativePrefix.length) {
      cursorPosition = cursorPosition.clamp(_numberFormat.negativePrefix.length + 1, formattedValue.length);
    } else {
      cursorPosition = cursorPosition.clamp(0, formattedValue.length);
    }

    // Check if backspace was pressed and formatted value is the same as oldValue
    if (newValue.text.length < oldValue.text.length && formattedValue == oldValue.text) {
      cursorPosition = cursorPosition - 1;
    }

    // Return the formatted value with correct cursor position
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  bool _startsWithSymbol(String value) {
    return value.contains(symbol);
  }

  bool _startsWithNegativeSign(String value) {
    return value.contains('-');
  }

  String _getDigitsOnly(String value) {
    return value.replaceAll(RegExp(r'[^\d,]'), '');
  }
}
