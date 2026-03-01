import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:budgetopia/common/components/date_picker/notifier/cyber_date_picker_selector_notifier.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_selector_value.dart';
import 'package:budgetopia/common/components/date_picker/widgets/cyber_date_picker_selector_adjacent_value.dart';
import 'package:flutter/material.dart';

class CyberDatePickerSelector extends StatefulWidget {
  const CyberDatePickerSelector({
    required this.selectedDate,
    required this.activeComponent,
    required this.glitchAnimation,
    required this.onDateChanged,
    super.key,
    this.firstDate,
    this.lastDate,
  });

  final DateTime selectedDate;
  final CyberDateComponent activeComponent;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Animation<double> glitchAnimation;
  final ValueChanged<DateTime> onDateChanged;

  @override
  State<CyberDatePickerSelector> createState() => _CyberDatePickerSelectorState();
}

class _CyberDatePickerSelectorState extends State<CyberDatePickerSelector> with SingleTickerProviderStateMixin {
  late AnimationController _componentAnimController;
  late Animation<double> _componentAnimation;
  late Animation<double> _dateRotationAnimation;

  late CyberDatePickerSelectorModel _model;

  @override
  void initState() {
    super.initState();

    _model = CyberDatePickerSelectorModel(
      selectedDate: widget.selectedDate,
      activeComponent: widget.activeComponent,
      onDateChanged: widget.onDateChanged,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    _componentAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _componentAnimation = CurvedAnimation(
      parent: _componentAnimController,
      curve: Curves.easeInOut,
    );

    _dateRotationAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(
        parent: _componentAnimController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(CyberDatePickerSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    _model = CyberDatePickerSelectorModel(
      selectedDate: widget.selectedDate,
      activeComponent: widget.activeComponent,
      onDateChanged: widget.onDateChanged,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (oldWidget.activeComponent != widget.activeComponent) {
      _componentAnimController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _componentAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _model,
      builder: (context, _) {
        final previousDate = _model.getPreviousValue();
        final nextDate = _model.getNextValue();

        return GestureDetector(
          onHorizontalDragStart: (_) => _model.onDragStart(),
          onHorizontalDragUpdate: (details) => _model.onDragUpdate(details),
          onHorizontalDragEnd: (_) => _model.onDragEnd(),
          child: SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CyberDatePickerSelectorAdjacentValue(
                  adjacentDate: previousDate,
                  model: _model,
                  position: AdjacentValuePosition.previous,
                  onTap: () => _model.onDateChanged(previousDate),
                ),
                CyberDatePickerSelectorValue(
                  model: _model,
                  glitchAnimation: widget.glitchAnimation,
                  componentAnimation: _componentAnimation,
                  dateRotationAnimation: _dateRotationAnimation,
                ),
                CyberDatePickerSelectorAdjacentValue(
                  adjacentDate: nextDate,
                  model: _model,
                  position: AdjacentValuePosition.next,
                  onTap: () => _model.onDateChanged(nextDate),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
