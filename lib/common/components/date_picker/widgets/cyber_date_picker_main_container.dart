import 'package:budgetopia/common/components/date_picker/cyber_date_picker_theme.dart';
import 'package:flutter/material.dart';

/// Widget for the main container of the date picker.
///
/// Organizes all date picker components including selector, input,
/// instructions, date display, and confirm button. Provides the visual
/// container with appropriate styling and layout.
class CyberDatePickerMainContainer extends StatelessWidget {
  /// Creates a [CyberDatePickerMainContainer].
  const CyberDatePickerMainContainer({
    required this.children,
    super.key,
  });

  /// The child widgets to be arranged in the container.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: context.backgroundColor,
        ),
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
