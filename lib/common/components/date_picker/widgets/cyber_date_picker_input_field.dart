import 'package:budgetopia/common/components/date_picker/cyber_date_picker_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CyberDatePickerInputField extends StatelessWidget {
  const CyberDatePickerInputField({
    required this.controller,
    required this.onSubmitted,
    required this.focusNode,
    required this.hintText,
    required this.onChanged,
    this.validator,
    this.nextFocus,
    this.monthController,
    this.yearController,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Function(String)? onChanged;
  final Function(String) onSubmitted;
  final String Function(String)? validator;
  final FocusNode? nextFocus;
  final TextEditingController? monthController;
  final TextEditingController? yearController;

  String _getDaysInMonth(int month, int year) {
    final daysInMonth = <int>[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    // Verificar se é ano bissexto
    if (month == 2 && ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))) {
      return '29';
    }

    return daysInMonth[month - 1].toString();
  }

  String _validateDayWithMonth(String value) {
    if (value.isEmpty) {
      return '';
    }

    try {
      // Limitar a 2 dígitos
      if (value.length > 2) {
        return value.substring(0, 2);
      }

      // Se tem 2 dígitos, validar considerando o mês
      if (value.length == 2) {
        final int day = int.parse(value);

        // Obter o mês se disponível
        int month = 1;
        if (monthController != null && monthController!.text.isNotEmpty) {
          try {
            month = int.parse(monthController!.text);
            if (month < 1 || month > 12) {
              month = 1;
            }
          } catch (e) {
            month = 1;
          }
        }

        // Obter o ano se disponível
        int year = 2025;
        if (yearController != null && yearController!.text.isNotEmpty) {
          try {
            year = int.parse(yearController!.text);
          } catch (e) {
            year = 2025;
          }
        }

        // Validar o dia máximo do mês
        final maxDaysInMonth = int.parse(_getDaysInMonth(month, year));
        if (day > maxDaysInMonth || day < 1) {
          // Se inválido, pega apenas o primeiro dígito
          return value[0];
        }
      }

      return value;
    } catch (e) {
      return '';
    }
  }

  void _handleChanged(String value) {
    // Aplicar validação se disponível
    if (validator != null) {
      String validatedValue;

      // Para dia, usar validação com contexto de mês
      if (hintText == 'DD') {
        validatedValue = _validateDayWithMonth(value);
      } else {
        validatedValue = validator!(value);
      }

      if (validatedValue != value) {
        controller.text = validatedValue;
        // Mover cursor para o fim
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: validatedValue.length),
        );
      }
    }

    // Chamar callback customizado
    onChanged?.call(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: context.valueTextStyle(fontSize: 25),
      decoration: context.dateInputDecoration(hintText),
      onChanged: _handleChanged,
      onTap: () {
        controller.selection = TextSelection.collapsed(offset: controller.text.length);
      },
      onSubmitted: onSubmitted,
      // Add glitch effect with shader
      cursorColor: context.accentColor,
      // Limit input length appropriately
      maxLength: hintText == 'AAAA' ? 4 : 2,
      // Hide counter text
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
      // Handle errors with cyberpunk style
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
