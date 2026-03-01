import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:budgetopia/common/components/date_picker/notifier/cyber_date_picker_notifier.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_component_selector.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_mode_content.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_instructions.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_date_display.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_confirm_button.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_main_container.dart';
import 'package:flutter/material.dart';

/// A cyberpunk-themed date picker component with dual input modes.
class CyberDatePicker extends StatefulWidget {
  /// Creates a [CyberDatePicker].
  const CyberDatePicker({
    required this.onDateSelected,
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  /// The initial date selected when the picker opens.
  final DateTime? initialDate;

  /// The earliest date the user can select.
  final DateTime? firstDate;

  /// The latest date the user can select.
  final DateTime? lastDate;

  /// Callback fired when the user confirms a date selection.
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<CyberDatePicker> createState() => _CyberDatePickerState();
}

class _CyberDatePickerState extends State<CyberDatePicker> with TickerProviderStateMixin {
  late CyberDatePickerModel _model;
  late AnimationController _glitchAnimController;
  late Animation<double> _glitchAnimation;

  @override
  void initState() {
    super.initState();
    _initializeModel();
    _initializeGlitchAnimation();
  }

  void _initializeModel() {
    final now = DateTime.now();
    final normalizedNow = DateTime(now.year, now.month, now.day);

    _model = CyberDatePickerModel(
      initialDate: widget.initialDate ?? normalizedNow,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
  }

  void _initializeGlitchAnimation() {
    _glitchAnimController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _glitchAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _glitchAnimController,
            curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
          ),
        );
  }

  @override
  void dispose() {
    _glitchAnimController.dispose();
    _model.dispose();
    super.dispose();
  }

  void _onConfirmPressed() {
    if (_model.mode == CyberDatePickerMode.input) {
      _model.updateDateFromInput();
    }

    final selectedDate = _model.selectedDate;
    widget.onDateSelected(selectedDate);
    Navigator.of(context).pop(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _model,
          builder: (context, child) {
            return Stack(
              children: [
                CyberDatePickerMainContainer(
                  children: [
                    CyberDatePickerComponentSelector(
                      mode: _model.mode,
                      activeComponent: _model.activeComponent,
                      onComponentSelected: _model.switchComponent,
                    ),
                    const SizedBox(height: 20),
                    CyberDatePickerModeContent(
                      model: _model,
                      glitchAnimation: _glitchAnimation,
                      firstDate: widget.firstDate,
                      lastDate: widget.lastDate,
                    ),
                    const SizedBox(height: 40),
                    CyberDatePickerInstructions(mode: _model.mode),
                    const SizedBox(height: 30),
                    CyberDatePickerDateDisplay(
                      selectedDate: _model.selectedDate,
                      mode: _model.mode,
                      onTap: _model.toggleMode,
                    ),
                    const SizedBox(height: 30),
                    CyberDatePickerConfirmButton(
                      onPressed: _onConfirmPressed,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
