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

  // Update date preview (para visualização em tempo real enquanto digita)
  void updateDatePreview() {
    try {
      int day = dayController.text.isNotEmpty ? int.parse(dayController.text) : _selectedDate.day;
      int month = monthController.text.isNotEmpty ? int.parse(monthController.text) : _selectedDate.month;
      int year = yearController.text.isNotEmpty ? int.parse(yearController.text) : _selectedDate.year;

      // Validar ranges básicos
      day = day.clamp(1, 31);
      month = month.clamp(1, 12);

      // Validar ano contra as restrições de data
      if (lastDate != null) {
        year = year.clamp(year, lastDate!.year);
      }
      if (firstDate != null) {
        year = year.clamp(firstDate!.year, year);
      }

      // Tentar criar a data
      try {
        _selectedDate = DateTime(year, month, day);
      } catch (e) {
        // Se inválido, usar o último dia do mês
        final lastDayOfMonth = DateTime(year, month + 1, 0).day;
        _selectedDate = DateTime(year, month, lastDayOfMonth);
      }

      notifyListeners();
    } catch (e) {
      // Ignorar erros
    }
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
        // Pega o último dia válido do mês
        final lastDayOfMonth = DateTime(year, month + 1, 0).day;
        day = lastDayOfMonth;
        newDate = DateTime(year, month, day);
      }

      // Aplicar restrições de data mínima e máxima
      if (firstDate != null && newDate.isBefore(firstDate!)) {
        newDate = firstDate!;
        day = newDate.day;
        month = newDate.month;
        year = newDate.year;
      }
      if (lastDate != null && newDate.isAfter(lastDate!)) {
        newDate = lastDate!;
        day = newDate.day;
        month = newDate.month;
        year = newDate.year;
      }

      // Atualizar os controllers com os valores validados
      dayController.text = day.toString().padLeft(2, '0');
      monthController.text = month.toString().padLeft(2, '0');
      yearController.text = year.toString();

      updateDate(newDate);
    } catch (e) {
      // Reset to current date if parsing fails
      _updateControllers();
    }
  }

  // Validar e corrigir dia
  String validateAndFixDay(String value) {
    if (value.isEmpty) {
      return '';
    }

    try {
      // Limitar a 2 dígitos
      if (value.length > 2) {
        return value.substring(0, 2);
      }

      // Se tem 2 dígitos, validar o valor
      if (value.length == 2) {
        final int day = int.parse(value);
        if (day > 31 || day < 1) {
          // Se inválido, pega apenas o primeiro dígito
          return value[0];
        }
      }

      return value;
    } catch (e) {
      return '';
    }
  }

  // Validar e corrigir mês
  String validateAndFixMonth(String value) {
    if (value.isEmpty) {
      return '';
    }

    try {
      // Limitar a 2 dígitos
      if (value.length > 2) {
        return value.substring(0, 2);
      }

      // Se tem 2 dígitos, validar o valor
      if (value.length == 2) {
        final int month = int.parse(value);
        if (month > 12 || month < 1) {
          // Se inválido, pega apenas o primeiro dígito
          return value[0];
        }
      }

      return value;
    } catch (e) {
      return '';
    }
  }

  // Validar e corrigir ano
  String validateAndFixYear(String value) {
    if (value.isEmpty) {
      return '';
    }

    try {
      // Permitir apenas 4 dígitos
      if (value.length > 4) {
        return value.substring(0, 4);
      }

      // Validar apenas quando tem 4 dígitos
      if (value.length == 4) {
        int year = int.parse(value);

        // Validar contra o lastDate se disponível
        if (lastDate != null && year > lastDate!.year) {
          year = lastDate!.year;
        }

        // Validar contra o firstDate se disponível
        if (firstDate != null && year < firstDate!.year) {
          year = firstDate!.year;
        }

        // Garantir que está entre minYear e maxYear
        if (year < CyberDatePickerConstants.minYear) {
          year = CyberDatePickerConstants.minYear;
        } else if (year > CyberDatePickerConstants.maxYear) {
          year = CyberDatePickerConstants.maxYear;
        }

        return year.toString();
      }

      return value;
    } catch (e) {
      return '';
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
