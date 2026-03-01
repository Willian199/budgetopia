import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:budgetopia/common/components/date_picker/cyber_date_picker_theme.dart';
import 'package:flutter/material.dart';

/// Widget that displays the selected date and toggles between modes on tap.
///
/// Shows the full date in DD MONTH YYYY format and provides visual feedback
/// about which mode can be switched to.
class CyberDatePickerDateDisplay extends StatelessWidget {
  /// Creates a [CyberDatePickerDateDisplay].
  const CyberDatePickerDateDisplay({
    required this.selectedDate,
    required this.mode,
    required this.onTap,
    super.key,
  });

  /// The currently selected date.
  final DateTime selectedDate;

  /// Current mode of the date picker.
  final CyberDatePickerMode mode;

  /// Callback when the display is tapped.
  final VoidCallback onTap;

  /// Formats the date for display with localized month name.
  String _formatDate() {
    const months = CyberDatePickerConstants.months;
    return '${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}';
  }

  /// Returns the icon indicating which mode can be switched to.
  IconData _getModeToggleIcon() {
    return mode == CyberDatePickerMode.selector ? Icons.edit : Icons.change_circle_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: context.dateDisplayDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatDate(),
              style: context.dateDisplayTextStyle(),
            ),
            const SizedBox(width: 10),
            Icon(
              _getModeToggleIcon(),
              color: context.accentColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
