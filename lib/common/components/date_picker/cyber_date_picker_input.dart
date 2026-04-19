import 'package:budgetopia/common/components/date_picker/notifier/cyber_date_picker_notifier.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_date_input_field.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_input_separator.dart';
import 'package:budgetopia/common/constantes/strings.dart';
import 'package:flutter/material.dart';

/// Input mode widget for direct date entry via text fields.
class CyberDatePickerInput extends StatelessWidget {
  const CyberDatePickerInput({
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.dayFocus,
    required this.monthFocus,
    required this.yearFocus,
    required this.onSubmitted,
    required this.model,
    super.key,
  });

  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;

  final FocusNode dayFocus;
  final FocusNode monthFocus;
  final FocusNode yearFocus;

  final ValueChanged<String> onSubmitted;
  final CyberDatePickerModel model;

  void _handleMonthChanged(String value) {
    model.updateDatePreview();

    if (value.length == 1) {
      final month = int.tryParse(value);
      if (month != null && month > 1) {
        yearFocus.requestFocus();
        return;
      }
    }

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
          CyberDatePickerDateInputField(
            controller: dayController,
            focusNode: dayFocus,
            hintText: Strings.DIA_HINT,
            width: 80,
            validator: model.validateAndFixDay,
            onChanged: (value) {
              model.updateDatePreview();
              if (value.length == 2) {
                monthFocus.requestFocus();
              }
            },
            onSubmitted: (_) => monthFocus.requestFocus(),
          ),
          const CyberDatePickerInputSeparator(),
          CyberDatePickerDateInputField(
            controller: monthController,
            focusNode: monthFocus,
            hintText: Strings.MES_HINT,
            width: 80,
            validator: model.validateAndFixMonth,
            onChanged: _handleMonthChanged,
            onSubmitted: (_) => yearFocus.requestFocus(),
          ),
          const CyberDatePickerInputSeparator(),
          CyberDatePickerDateInputField(
            controller: yearController,
            focusNode: yearFocus,
            hintText: Strings.ANO_HINT,
            width: 100,
            validator: model.validateAndFixYear,
            onChanged: (_) => model.updateDatePreview(),
            onSubmitted: onSubmitted,
          ),
        ],
      ),
    );
  }
}
