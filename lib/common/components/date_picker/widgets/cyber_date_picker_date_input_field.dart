import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_input_field.dart';
import 'package:flutter/material.dart';

/// Generic widget for input fields in DD/MM/YYYY format.
class CyberDatePickerDateInputField extends StatelessWidget {
  const CyberDatePickerDateInputField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.width,
    required this.onChanged,
    required this.onSubmitted,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final double width;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final String Function(String)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: CyberDatePickerInputField(
        controller: controller,
        focusNode: focusNode,
        hintText: hintText,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        validator: validator,
      ),
    );
  }
}
