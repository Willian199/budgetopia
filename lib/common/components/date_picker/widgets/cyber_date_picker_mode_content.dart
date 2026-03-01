import 'package:budgetopia/common/components/date_picker/cyber_date_picker_input.dart';
import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:budgetopia/common/components/date_picker/cyber_date_picker_selector.dart';
import 'package:budgetopia/common/components/date_picker/notifier/cyber_date_picker_notifier.dart';
import 'package:flutter/material.dart';

/// Widget that switches between selector and input modes with animation.
///
/// Provides smooth fade transitions when switching between
/// swipe-based selector and text-input modes.
class CyberDatePickerModeContent extends StatelessWidget {
  /// Creates a [CyberDatePickerModeContent].
  const CyberDatePickerModeContent({
    required this.model,
    required this.glitchAnimation,
    required this.firstDate,
    required this.lastDate,
    super.key,
  });

  /// The date picker model.
  final CyberDatePickerModel model;

  /// Animation for the glitch effect.
  final Animation<double> glitchAnimation;

  /// Earliest selectable date.
  final DateTime? firstDate;

  /// Latest selectable date.
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: model.mode == CyberDatePickerMode.selector
          ? CyberDatePickerSelector(
              key: const ValueKey(CyberDatePickerMode.selector),
              selectedDate: model.selectedDate,
              activeComponent: model.activeComponent,
              firstDate: firstDate,
              lastDate: lastDate,
              glitchAnimation: glitchAnimation,
              onDateChanged: model.updateDate,
            )
          : CyberDatePickerInput(
              key: const ValueKey(CyberDatePickerMode.input),
              dayController: model.dayController,
              monthController: model.monthController,
              yearController: model.yearController,
              dayFocus: model.dayFocus,
              monthFocus: model.monthFocus,
              yearFocus: model.yearFocus,
              model: model,
              onSubmitted: (_) => model.updateDateFromInput(),
            ),
    );
  }
}
