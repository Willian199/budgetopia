import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:flutter/material.dart';

/// Model class managing the state and business logic of the CyberDatePicker.
class CyberDatePickerModel extends ChangeNotifier {
  CyberDatePickerModel({
    required DateTime initialDate,
    this.firstDate,
    this.lastDate,
  }) : _activeComponent = CyberDateComponent.day,
       _mode = CyberDatePickerMode.selector,
       _selectedDate = _validateDateConstraints(initialDate, firstDate, lastDate),
       dayController = TextEditingController(),
       monthController = TextEditingController(),
       yearController = TextEditingController(),
       dayFocus = FocusNode(),
       monthFocus = FocusNode(),
       yearFocus = FocusNode() {
    final normalizedFirstDate = firstDate == null ? null : _toDateOnly(firstDate!);
    final normalizedLastDate = lastDate == null ? null : _toDateOnly(lastDate!);

    assert(
      normalizedFirstDate == null || normalizedLastDate == null || !normalizedFirstDate.isAfter(normalizedLastDate),
      'firstDate must be on or before lastDate',
    );

    _updateControllers();
  }

  DateTime _selectedDate;
  CyberDateComponent _activeComponent;
  CyberDatePickerMode _mode;
  bool _isDisposed = false;

  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;

  final FocusNode dayFocus;
  final FocusNode monthFocus;
  final FocusNode yearFocus;

  final DateTime? firstDate;
  final DateTime? lastDate;

  DateTime get selectedDate => _selectedDate;
  CyberDateComponent get activeComponent => _activeComponent;
  CyberDatePickerMode get mode => _mode;

  static DateTime _toDateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  static DateTime _validateDateConstraints(
    DateTime date,
    DateTime? firstDate,
    DateTime? lastDate,
  ) {
    var result = _toDateOnly(date);
    final normalizedFirstDate = firstDate == null ? null : _toDateOnly(firstDate);
    final normalizedLastDate = lastDate == null ? null : _toDateOnly(lastDate);

    if (normalizedFirstDate != null && result.isBefore(normalizedFirstDate)) {
      result = normalizedFirstDate;
    }
    if (normalizedLastDate != null && result.isAfter(normalizedLastDate)) {
      result = normalizedLastDate;
    }

    return result;
  }

  void _updateControllers() {
    dayController.text = _selectedDate.day.toString().padLeft(2, '0');
    monthController.text = _selectedDate.month.toString().padLeft(2, '0');
    yearController.text = _selectedDate.year.toString();
  }

  int _yearMin() => firstDate?.year ?? CyberDatePickerConstants.minYear;
  int _yearMax() => lastDate?.year ?? CyberDatePickerConstants.maxYear;

  int? _tryParseInt(String value) => value.isEmpty ? null : int.tryParse(value);

  int _currentInputMonth() {
    final parsed = _tryParseInt(monthController.text);
    return (parsed ?? _selectedDate.month).clamp(1, 12);
  }

  int _currentInputYear() {
    final parsed = _tryParseInt(yearController.text);
    return (parsed ?? _selectedDate.year).clamp(_yearMin(), _yearMax());
  }

  void updateDate(DateTime newDate) {
    _selectedDate = _validateDateConstraints(newDate, firstDate, lastDate);
    _updateControllers();
    notifyListeners();
  }

  void switchComponent(CyberDateComponent component) {
    if (_activeComponent == component) {
      return;
    }

    _activeComponent = component;
    notifyListeners();
  }

  void updateDatePreview() {
    final day = (_tryParseInt(dayController.text) ?? _selectedDate.day).clamp(1, 31);
    final month = (_tryParseInt(monthController.text) ?? _selectedDate.month).clamp(1, 12);
    final year = (_tryParseInt(yearController.text) ?? _selectedDate.year).clamp(_yearMin(), _yearMax());

    final previewDate = _createValidDate(year, month, day);
    _selectedDate = _validateDateConstraints(previewDate, firstDate, lastDate);
    notifyListeners();
  }

  static DateTime _createValidDate(int year, int month, int day) {
    final lastDayOfMonth = DateTime(year, month + 1, 0).day;
    final safeDay = day.clamp(1, lastDayOfMonth);
    return DateTime(year, month, safeDay);
  }

  void toggleMode() {
    if (_mode == CyberDatePickerMode.selector) {
      _mode = CyberDatePickerMode.input;
      notifyListeners();

      Future.delayed(const Duration(milliseconds: 300), () {
        if (_isDisposed) {
          return;
        }

        switch (_activeComponent) {
          case CyberDateComponent.day:
            dayFocus.requestFocus();
          case CyberDateComponent.month:
            monthFocus.requestFocus();
          case CyberDateComponent.year:
            yearFocus.requestFocus();
        }
      });
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    _mode = CyberDatePickerMode.selector;
    notifyListeners();
  }

  void updateDateFromInput() {
    final parsedDay = _tryParseInt(dayController.text);
    final parsedMonth = _tryParseInt(monthController.text);
    final parsedYear = _tryParseInt(yearController.text);

    if (parsedDay == null || parsedMonth == null || parsedYear == null) {
      _updateControllers();
      return;
    }

    final day = parsedDay.clamp(1, 31);
    final month = parsedMonth.clamp(1, 12);
    final year = parsedYear.clamp(_yearMin(), _yearMax());

    final validDate = _validateDateConstraints(
      _createValidDate(year, month, day),
      firstDate,
      lastDate,
    );

    _selectedDate = validDate;
    _updateControllers();
    notifyListeners();
  }

  String validateAndFixDay(String value) {
    if (value.isEmpty) {
      return '';
    }

    final sanitized = value.replaceAll(RegExp(r'\D'), '');
    if (sanitized.length > 2) {
      return sanitized.substring(0, 2);
    }

    final day = int.tryParse(sanitized);
    if (day == null) {
      return '';
    }

    if (sanitized.length == 2) {
      final maxDays = DateTime(_currentInputYear(), _currentInputMonth() + 1, 0).day;
      if (day < 1 || day > maxDays) {
        return sanitized[0];
      }
    }

    return sanitized;
  }

  String validateAndFixMonth(String value) {
    if (value.isEmpty) {
      return '';
    }

    final sanitized = value.replaceAll(RegExp(r'\D'), '');
    if (sanitized.length > 2) {
      return sanitized.substring(0, 2);
    }

    final month = int.tryParse(sanitized);
    if (month == null) {
      return '';
    }

    if (sanitized.length == 2 && (month < 1 || month > 12)) {
      return sanitized[0];
    }

    return sanitized;
  }

  String validateAndFixYear(String value) {
    if (value.isEmpty) {
      return '';
    }

    final sanitized = value.replaceAll(RegExp(r'\D'), '');
    if (sanitized.length > 4) {
      return sanitized.substring(0, 4);
    }

    if (sanitized.length < 4) {
      return sanitized;
    }

    final parsedYear = int.tryParse(sanitized);
    if (parsedYear == null) {
      return '';
    }

    final clampedYear = parsedYear.clamp(_yearMin(), _yearMax());
    return clampedYear.toString();
  }

  @override
  void dispose() {
    _isDisposed = true;
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    dayFocus.dispose();
    monthFocus.dispose();
    yearFocus.dispose();
    super.dispose();
  }
}
