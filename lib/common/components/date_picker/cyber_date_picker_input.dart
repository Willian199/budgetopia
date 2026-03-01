import 'package:budgetopia/common/components/date_picker/notifier/cyber_date_picker_notifier.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_input_field.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_input_separator.dart';
import 'package:flutter/material.dart';

/// Input mode for direct date entry
class CyberDatePickerInput extends StatelessWidget {
  const CyberDatePickerInput({
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.dayFocus,
    required this.monthFocus,
    required this.yearFocus,
    required this.onSubmitted,
    this.model,
    super.key,
  });
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final FocusNode dayFocus;
  final FocusNode monthFocus;
  final FocusNode yearFocus;
  final Function(String) onSubmitted;
  final CyberDatePickerModel? model;

  // Validar e ajustar o dia quando o mês mudar
  void _validateDayForMonth() {
    if (dayController.text.isEmpty || monthController.text.isEmpty) {
      return;
    }

    try {
      final int day = int.parse(dayController.text);
      final int month = int.parse(monthController.text);
      final int year = yearController.text.isNotEmpty ? int.parse(yearController.text) : 2025;

      final daysInMonth = DateTime(year, month + 1, 0).day;

      // Se o dia é maior que os dias do mês, ajustar para o máximo
      // Isso já valida automaticamente 29/02 para anos bissextos!
      if (day > daysInMonth) {
        dayController.text = daysInMonth.toString().padLeft(2, '0');
      }
    } catch (e) {
      // Ignorar erros de parsing
    }
  }

  // Navegar para o próximo campo (para day/month)
  void _handleDaySubmitted() {
    monthFocus.requestFocus();
  }

  // Navegar para o ano quando o mês estiver completo ou inválido
  void _handleMonthSubmitted() {
    yearFocus.requestFocus();
  }

  // Callback para o mês com navegação inteligente
  void _handleMonthChanged(String value) {
    // Validar o dia quando o mês muda
    _validateDayForMonth();
    // Atualizar preview da data
    model?.updateDatePreview();

    // Se tem 1 dígito e é maior que 1, navegar para ano
    // (porque o máximo para mês é 12, então 2-9 só podem ser primeiro dígito)
    if (value.length == 1) {
      final int month = int.parse(value);
      if (month > 1) {
        // Já sabemos que será 2X máximo, então navega
        yearFocus.requestFocus();
        return;
      }
    }

    // Se tem 2 dígitos, já está completo, navega
    if (value.length == 2) {
      yearFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Day input
          Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: CyberDatePickerInputField(
              controller: dayController,
              onSubmitted: (_) => _handleDaySubmitted(),
              focusNode: dayFocus,
              hintText: 'DD',
              nextFocus: monthFocus,
              monthController: monthController,
              yearController: yearController,
              validator: model?.validateAndFixDay,
              onChanged: (value) {
                // Atualizar preview da data
                model?.updateDatePreview();
                if (value.length == 2) {
                  monthFocus.requestFocus();
                }
              },
            ),
          ),

          const CyberDatePickerInputSeparator(),

          // Month input
          Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: CyberDatePickerInputField(
              controller: monthController,
              focusNode: monthFocus,
              onSubmitted: (_) => _handleMonthSubmitted(),
              hintText: 'MM',
              nextFocus: yearFocus,
              validator: model?.validateAndFixMonth,
              onChanged: _handleMonthChanged,
            ),
          ),

          const CyberDatePickerInputSeparator(),

          // Year input
          Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: CyberDatePickerInputField(
              controller: yearController,
              focusNode: yearFocus,
              hintText: 'AAAA',
              validator: model?.validateAndFixYear,
              onChanged: (value) {
                // Validar o dia quando o ano muda (importante para anos bissextos)
                // Validar sempre que houver qualquer mudança no ano
                _validateDayForMonth();
                // Atualizar preview da data
                model?.updateDatePreview();
              },
              onSubmitted: onSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
