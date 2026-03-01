import 'package:budgetopia/common/components/date_picker/cyber_date_picker_theme.dart';
import 'package:flutter/material.dart';

/// Widget for the confirm button in the date picker.
///
/// Displays a styled button that submits the selected date.
class CyberDatePickerConfirmButton extends StatelessWidget {
  /// Creates a [CyberDatePickerConfirmButton].
  const CyberDatePickerConfirmButton({
    required this.onPressed,
    super.key,
  });

  /// Callback when the button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: context.confirmButtonStyle(),
      child: const Text(
        'CONFIRMAR DATA',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
