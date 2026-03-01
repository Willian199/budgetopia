import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_component_button.dart';
import 'package:flutter/material.dart';

/// Component selector buttons (Day/Month/Year)
///
/// Provides a row of toggle buttons for selecting which date component
/// (day, month, or year) the user wants to adjust.
class CyberDatePickerSelectorType extends StatelessWidget {
  /// Creates a [CyberDatePickerSelectorType].
  const CyberDatePickerSelectorType({
    required this.activeComponent,
    required this.onComponentSelected,
    super.key,
  });

  /// The currently selected component.
  final CyberDateComponent activeComponent;

  /// Callback when a component button is tapped.
  final ValueChanged<CyberDateComponent> onComponentSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CyberDatePickerComponentButton(
          label: 'DIA',
          isActive: activeComponent == CyberDateComponent.day,
          onTap: () => onComponentSelected(CyberDateComponent.day),
        ),
        const SizedBox(width: 15),
        CyberDatePickerComponentButton(
          label: 'MES',
          isActive: activeComponent == CyberDateComponent.month,
          onTap: () => onComponentSelected(CyberDateComponent.month),
        ),
        const SizedBox(width: 15),
        CyberDatePickerComponentButton(
          label: 'ANO',
          isActive: activeComponent == CyberDateComponent.year,
          onTap: () => onComponentSelected(CyberDateComponent.year),
        ),
      ],
    );
  }
}
