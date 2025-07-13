// DatePicker ChangeNotifier
import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:flutter/material.dart';

class CyberDatePickerModel extends ChangeNotifier {
  CyberDatePickerModel({
    required DateTime initialDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
  }) : _selectedDate = initialDate,
       _activeComponent = CyberDateComponent.day,
       _mode = CyberDatePickerMode.selector,
       dayController = TextEditingController(text: initialDate.day.toString()),
       monthController = TextEditingController(text: initialDate.month.toString()),
       yearController = TextEditingController(text: initialDate.year.toString()),
       dayFocus = FocusNode(),
       monthFocus = FocusNode(),
       yearFocus = FocusNode() {
    _applyDateConstraints();
  }

  DateTime _selectedDate;
  CyberDateComponent _activeComponent;
  CyberDatePickerMode _mode;

  // Text controllers
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;

  // Focus nodes
  final FocusNode dayFocus;
  final FocusNode monthFocus;
  final FocusNode yearFocus;

  // Date constraints
  final DateTime? firstDate;
  final DateTime? lastDate;

  // Callback
  final Function(DateTime) onDateSelected;

  // Getters
  DateTime get selectedDate => _selectedDate;
  CyberDateComponent get activeComponent => _activeComponent;
  CyberDatePickerMode get mode => _mode;

  // Apply date constraints
  void _applyDateConstraints() {
    if (firstDate != null && _selectedDate.isBefore(firstDate!)) {
      _selectedDate = firstDate!;
      _updateControllers();
    }
    if (lastDate != null && _selectedDate.isAfter(lastDate!)) {
      _selectedDate = lastDate!;
      _updateControllers();
    }
  }

  // Update text controllers
  void _updateControllers() {
    dayController.text = _selectedDate.day.toString();
    monthController.text = _selectedDate.month.toString();
    yearController.text = _selectedDate.year.toString();
  }

  // Update date
  void updateDate(DateTime newDate) {
    _selectedDate = newDate;
    _updateControllers();
    onDateSelected(_selectedDate);
    notifyListeners();
  }

  // Switch active component
  void switchComponent(CyberDateComponent component) {
    _activeComponent = component;
    notifyListeners();
  }

  // Toggle between selector and input mode
  void toggleMode() {
    if (_mode == CyberDatePickerMode.selector) {
      _mode = CyberDatePickerMode.input;
      notifyListeners();

      // Focus on appropriate field
      Future.delayed(const Duration(milliseconds: 300), () {
        switch (_activeComponent) {
          case CyberDateComponent.day:
            dayFocus.requestFocus();
            break;
          case CyberDateComponent.month:
            monthFocus.requestFocus();
            break;
          case CyberDateComponent.year:
            yearFocus.requestFocus();
            break;
        }
      });
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      _mode = CyberDatePickerMode.selector;
      notifyListeners();
    }
  }

  // Update date from text input
  void updateDateFromInput() {
    try {
      int day = int.parse(dayController.text);
      int month = int.parse(monthController.text);
      int year = int.parse(yearController.text);

      // Validate ranges
      day = day.clamp(1, 31);
      month = month.clamp(1, 12);
      year = year.clamp(CyberDatePickerConstants.minYear, CyberDatePickerConstants.maxYear);

      // Try to create a valid date
      DateTime newDate;

      try {
        newDate = DateTime(year, month, day);
      } catch (e) {
        // Handle invalid dates (e.g., Feb 30)
        newDate = DateTime(year, month);
        dayController.text = "1";
      }

      updateDate(newDate);
    } catch (e) {
      // Reset to current date if parsing fails
      _updateControllers();
    }
  }

  // Clean up resources
  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    dayFocus.dispose();
    monthFocus.dispose();
    yearFocus.dispose();
    super.dispose();
  }
}
