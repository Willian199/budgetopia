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
    super.key,
  });
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final FocusNode dayFocus;
  final FocusNode monthFocus;
  final FocusNode yearFocus;
  final Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Day input
          Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: CyberDatePickerInputField(
              controller: dayController,
              onSubmitted: onSubmitted,
              focusNode: dayFocus,
              hintText: 'DD',
              onChanged: (value) {
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
              onSubmitted: onSubmitted,
              hintText: 'MM',
              onChanged: (value) {
                if (value.length == 2) {
                  yearFocus.requestFocus();
                }
              },
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
              hintText: 'YYYY',
              onChanged: null,
              onSubmitted: onSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
