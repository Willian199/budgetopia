import 'package:budgetopia/common/components/date_picker/cyber_date_picker_theme.dart';
import 'package:budgetopia/common/constantes/strings.dart';
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
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String> onSubmitted;
  final String Function(String)? validator;

  void _handleChanged(String value) {
    if (validator != null) {
      final validatedValue = validator!(value);

      if (validatedValue != value) {
        controller.text = validatedValue;
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: validatedValue.length),
        );
      }
    }

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
      cursorColor: context.accentColor,
      maxLength: hintText == Strings.ANO_HINT ? 4 : 2,
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
