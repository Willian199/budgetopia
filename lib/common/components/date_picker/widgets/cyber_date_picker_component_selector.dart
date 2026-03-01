import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_selector_type.dart';
import 'package:flutter/material.dart';

/// Widget for the component selector (day/month/year tabs).
///
/// Only visible in selector mode. Allows user to switch between
/// day, month, and year selection.
class CyberDatePickerComponentSelector extends StatelessWidget {
  /// Creates a [CyberDatePickerComponentSelector].
  const CyberDatePickerComponentSelector({
    required this.mode,
    required this.activeComponent,
    required this.onComponentSelected,
    super.key,
  });

  /// Current mode of the date picker.
  final CyberDatePickerMode mode;

  /// Currently active component (day/month/year).
  final CyberDateComponent activeComponent;

  /// Callback when a component is selected.
  final ValueChanged<CyberDateComponent> onComponentSelected;

  @override
  Widget build(BuildContext context) {
    final isSelectorMode = mode == CyberDatePickerMode.selector;

    return IgnorePointer(
      ignoring: !isSelectorMode,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isSelectorMode ? 1.0 : 0.0,
        child: CyberDatePickerSelectorType(
          activeComponent: activeComponent,
          onComponentSelected: onComponentSelected,
        ),
      ),
    );
  }
}
