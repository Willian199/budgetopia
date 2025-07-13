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
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Function(String)? onChanged;
  final Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: context.valueTextStyle(fontSize: 25),
      decoration: context.dateInputDecoration(hintText),
      onChanged: onChanged,
      onTap: () {
        controller.selection = TextSelection.collapsed(offset: controller.text.length);
      },
      onSubmitted: onSubmitted,
      // Add glitch effect with shader
      cursorColor: context.accentColor,
      // Limit input length appropriately
      maxLength: hintText == 'YYYY' ? 4 : 2,
      // Hide counter text
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
      // Handle errors with cyberpunk style
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
