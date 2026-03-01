import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:budgetopia/common/components/date_picker/cyber_date_picker_theme.dart';
import 'package:budgetopia/common/components/date_picker/notifier/cyber_date_picker_selector_notifier.dart';
import 'package:flutter/material.dart';

/// Widget for displaying and selecting adjacent date values in the selector.
///
/// Renders a date value (previous or next) with opacity effect to the side
/// of the current date selector. Tapping applies that adjacent date value.
///
/// The [position] parameter controls whether the value appears to the left
/// (previous) or right (next) of the current value.
class CyberDatePickerSelectorAdjacentValue extends StatelessWidget {
  /// Creates a [CyberDatePickerSelectorAdjacentValue].
  const CyberDatePickerSelectorAdjacentValue({
    required this.adjacentDate,
    required this.model,
    required this.onTap,
    required this.position,
    super.key,
  });

  /// The date value to display.
  final DateTime adjacentDate;

  /// The selector model providing formatting and state information.
  final CyberDatePickerSelectorModel model;

  /// Callback when this value is selected.
  final VoidCallback onTap;

  /// Position of this value relative to the current value.
  ///
  /// Use [AdjacentValuePosition.previous] for values to the left,
  /// or [AdjacentValuePosition.next] for values to the right.
  final AdjacentValuePosition position;

  @override
  Widget build(BuildContext context) {
    if (adjacentDate.isAtSameMomentAs(model.selectedDate)) {
      return const SizedBox(width: 90);
    }

    return Padding(
      padding: position == AdjacentValuePosition.previous
          ? const EdgeInsets.only(right: 10)
          : const EdgeInsets.only(left: 10),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 80,
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: 0.5,
              child: Text(
                model.getFormattedValue(adjacentDate),
                style: TextStyle(
                  fontSize: model.activeComponent == CyberDateComponent.day ? 40 : 30,
                  color: context.accentColor.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Enum to specify the position of an adjacent value in the selector.
enum AdjacentValuePosition {
  /// Value appears to the left (previous value).
  previous,

  /// Value appears to the right (next value).
  next,
}
