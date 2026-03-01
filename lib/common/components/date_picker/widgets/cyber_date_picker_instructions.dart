import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:budgetopia/common/components/date_picker/cyber_date_picker_theme.dart';
import 'package:flutter/material.dart';

/// Widget that displays instructions based on the current mode.
///
/// Shows different instructions for selector mode (swipe gestures)
/// and input mode (text entry).
class CyberDatePickerInstructions extends StatelessWidget {
  /// Creates a [CyberDatePickerInstructions].
  const CyberDatePickerInstructions({
    required this.mode,
    super.key,
  });

  /// Current mode of the date picker.
  final CyberDatePickerMode mode;

  /// Returns the appropriate instruction text for the current mode.
  String _getInstructionText() {
    return mode == CyberDatePickerMode.selector
        ? 'Deslize horizontalmente para mudar o valor\nToque nos botões para mudar o campo'
        : 'Digite a data no formato DD/MM/AAAA';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          _getInstructionText(),
          textAlign: TextAlign.center,
          style: context.instructionTextStyle(),
        ),
      ),
    );
  }
}
