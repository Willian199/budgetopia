import 'package:budgetopia/common/components/date_picker/cyber_date_picker_theme.dart';
import 'package:flutter/material.dart';

/// Widget for a single component button (Day/Month/Year) in the selector.
///
/// Displays a styled button that toggles between active and inactive states
/// when tapped. Used within [CyberDatePickerSelectorType].
class CyberDatePickerComponentButton extends StatelessWidget {
  /// Creates a [CyberDatePickerComponentButton].
  const CyberDatePickerComponentButton({
    required this.label,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  /// The label text for this button (e.g., 'DIA', 'MES', 'ANO').
  final String label;

  /// Whether this component is currently selected.
  final bool isActive;

  /// Callback when the button is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: context.componentButtonDecoration(isActive: isActive),
        child: Text(
          label,
          style: context.componentButtonTextStyle(isActive: isActive),
        ),
      ),
    );
  }
}
