import 'package:budgetopia/common/components/date_picker/cyber_date_picker_models.dart';
import 'package:flutter/material.dart';

class CyberDatePickerSelectorModel extends ChangeNotifier {
  CyberDatePickerSelectorModel({
    required this.selectedDate,
    required this.activeComponent,
    required this.onDateChanged,
    this.firstDate,
    this.lastDate,
  });

  final DateTime selectedDate;
  final CyberDateComponent activeComponent;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDateChanged;

  double _horizontalDragAmount = 0.0;

  double get horizontalDragAmount => _horizontalDragAmount;

  static DateTime _toDateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  DateTime? get _normalizedFirstDate => firstDate == null ? null : _toDateOnly(firstDate!);
  DateTime? get _normalizedLastDate => lastDate == null ? null : _toDateOnly(lastDate!);

  void onDragStart() {
    _horizontalDragAmount = 0;
    notifyListeners();
  }

  void onDragUpdate(DragUpdateDetails details) {
    _horizontalDragAmount += details.delta.dx;
    notifyListeners();
    _changeDateValue(_horizontalDragAmount);
  }

  void onDragEnd() {
    _horizontalDragAmount = 0;
    notifyListeners();
  }

  DateTime _normalizeDate(DateTime baseDate, {int dayChange = 0, int monthChange = 0, int yearChange = 0}) {
    var newYear = baseDate.year + yearChange;
    var newMonth = baseDate.month + monthChange;
    var newDay = baseDate.day + dayChange;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }

    while (true) {
      final daysInMonth = DateTime(newYear, newMonth + 1, 0).day;

      if (newDay > daysInMonth) {
        newDay -= daysInMonth;
        newMonth++;
        if (newMonth > 12) {
          newMonth = 1;
          newYear++;
        }
      } else if (newDay < 1) {
        newMonth--;
        if (newMonth < 1) {
          newMonth = 12;
          newYear--;
        }
        newDay += DateTime(newYear, newMonth + 1, 0).day;
      } else {
        break;
      }
    }

    return DateTime(newYear, newMonth, newDay);
  }

  DateTime _calculateNewDate(DateTime baseDate, {int dayChange = 0, int monthChange = 0, int yearChange = 0}) {
    final newDate = _normalizeDate(
      baseDate,
      dayChange: dayChange,
      monthChange: monthChange,
      yearChange: yearChange,
    );

    final normalizedFirstDate = _normalizedFirstDate;
    final normalizedLastDate = _normalizedLastDate;

    if (normalizedFirstDate != null && newDate.isBefore(normalizedFirstDate)) {
      return normalizedFirstDate;
    }
    if (normalizedLastDate != null && newDate.isAfter(normalizedLastDate)) {
      return normalizedLastDate;
    }

    return newDate;
  }

  void _changeDateValue(double dragAmount) {
    final change = dragAmount > 20 ? -1 : (dragAmount < -20 ? 1 : 0);

    if (change == 0) {
      return;
    }

    _horizontalDragAmount = 0;

    DateTime newDate;

    switch (activeComponent) {
      case CyberDateComponent.day:
        newDate = _calculateNewDate(selectedDate, dayChange: change);
        break;
      case CyberDateComponent.month:
        newDate = _calculateNewDate(selectedDate, monthChange: change);
        break;
      case CyberDateComponent.year:
        newDate = _calculateNewDate(selectedDate, yearChange: change);
        break;
    }

    onDateChanged(newDate);
  }

  DateTime getPreviousValue() {
    DateTime previousDate;

    switch (activeComponent) {
      case CyberDateComponent.day:
        previousDate = _normalizeDate(selectedDate, dayChange: -1);
        break;
      case CyberDateComponent.month:
        previousDate = _normalizeDate(selectedDate, monthChange: -1);
        break;
      case CyberDateComponent.year:
        previousDate = _normalizeDate(selectedDate, yearChange: -1);
        break;
    }

    final normalizedFirstDate = _normalizedFirstDate;
    final normalizedLastDate = _normalizedLastDate;

    if (normalizedFirstDate != null && previousDate.isBefore(normalizedFirstDate)) {
      return selectedDate;
    }
    if (normalizedLastDate != null && previousDate.isAfter(normalizedLastDate)) {
      return selectedDate;
    }

    return previousDate;
  }

  DateTime getNextValue() {
    DateTime nextDate;

    switch (activeComponent) {
      case CyberDateComponent.day:
        nextDate = _normalizeDate(selectedDate, dayChange: 1);
        break;
      case CyberDateComponent.month:
        nextDate = _normalizeDate(selectedDate, monthChange: 1);
        break;
      case CyberDateComponent.year:
        nextDate = _normalizeDate(selectedDate, yearChange: 1);
        break;
    }

    final normalizedFirstDate = _normalizedFirstDate;
    final normalizedLastDate = _normalizedLastDate;

    if (normalizedFirstDate != null && nextDate.isBefore(normalizedFirstDate)) {
      return selectedDate;
    }
    if (normalizedLastDate != null && nextDate.isAfter(normalizedLastDate)) {
      return selectedDate;
    }

    return nextDate;
  }

  String getFormattedValue(DateTime date) {
    switch (activeComponent) {
      case CyberDateComponent.day:
        return '${date.day}';
      case CyberDateComponent.month:
        return CyberDatePickerConstants.months[date.month - 1];
      case CyberDateComponent.year:
        return '${date.year}';
    }
  }

  double getFontSize() {
    switch (activeComponent) {
      case CyberDateComponent.day:
        return 120;
      case CyberDateComponent.month:
        return 70;
      case CyberDateComponent.year:
        return 60;
    }
  }
}
