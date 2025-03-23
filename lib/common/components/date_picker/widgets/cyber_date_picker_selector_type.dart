import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:budgetopia/common/components/date_picker/cyber_date_picker_theme.dart';
import 'package:flutter/material.dart';

/// Component selector buttons (Day/Month/Year)
class CyberDatePickerSelectorType extends StatelessWidget {
  const CyberDatePickerSelectorType({
    required this.activeComponent,
    required this.onComponentSelected,
    super.key,
  });
  final CyberDateComponent activeComponent;
  final Function(CyberDateComponent) onComponentSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildComponentButton(context, 'DAY', CyberDateComponent.day),
        const SizedBox(width: 15),
        _buildComponentButton(context, 'MONTH', CyberDateComponent.month),
        const SizedBox(width: 15),
        _buildComponentButton(context, 'YEAR', CyberDateComponent.year),
      ],
    );
  }

  Widget _buildComponentButton(BuildContext context, String label, CyberDateComponent component) {
    final isActive = activeComponent == component;

    return GestureDetector(
      onTap: () => onComponentSelected(component),
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
