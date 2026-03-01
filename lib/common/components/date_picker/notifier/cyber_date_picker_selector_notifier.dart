// Modelo para o Selector do DatePicker
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
  // Estado
  final DateTime selectedDate;
  final CyberDateComponent activeComponent;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime) onDateChanged;

  // Para horizontal drag
  double _horizontalDragAmount = 0.0;

  // Getter para o valor do drag horizontal
  double get horizontalDragAmount => _horizontalDragAmount;

  // Método para iniciar o drag
  void onDragStart() {
    _horizontalDragAmount = 0;
    notifyListeners();
  }

  // Método para atualizar o valor de drag
  void onDragUpdate(DragUpdateDetails details) {
    _horizontalDragAmount += details.delta.dx;
    notifyListeners();

    // Chama o método para mudar a data baseado no valor de drag
    _changeDateValue(_horizontalDragAmount);
  }

  // Método para finalizar o drag
  void onDragEnd() {
    _horizontalDragAmount = 0;
    notifyListeners();
  }

  // Normalizar data sem aplicar restrições (para visualização de valores adjacentes)
  DateTime _normalizeDate(DateTime baseDate, {int dayChange = 0, int monthChange = 0, int yearChange = 0}) {
    int newYear = baseDate.year + yearChange;
    int newMonth = baseDate.month + monthChange;
    int newDay = baseDate.day + dayChange;

    // Normalizar mês
    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }

    // Normalizar dia - garantir que seja válido para o mês/ano
    while (true) {
      final daysInMonth = DateTime(newYear, newMonth + 1, 0).day;

      if (newDay > daysInMonth) {
        // Dia excede o mês, vai para próximo mês
        newDay -= daysInMonth;
        newMonth++;
        if (newMonth > 12) {
          newMonth = 1;
          newYear++;
        }
      } else if (newDay < 1) {
        // Dia negativo, volta para mês anterior
        newMonth--;
        if (newMonth < 1) {
          newMonth = 12;
          newYear--;
        }
        newDay += DateTime(newYear, newMonth + 1, 0).day;
      } else {
        // Dia válido, sair do loop
        break;
      }
    }

    return DateTime(newYear, newMonth, newDay);
  }

  // Calcular nova data com restrições (para mudanças efetivas do usuário)
  DateTime _calculateNewDate(DateTime baseDate, {int dayChange = 0, int monthChange = 0, int yearChange = 0}) {
    final DateTime newDate = _normalizeDate(
      baseDate,
      dayChange: dayChange,
      monthChange: monthChange,
      yearChange: yearChange,
    );

    // Aplicar restrições caso existam
    if (firstDate != null && newDate.isBefore(firstDate!)) {
      return firstDate!;
    }
    if (lastDate != null && newDate.isAfter(lastDate!)) {
      return lastDate!;
    }

    return newDate;
  }

  // Mudar valor da data baseado no componente ativo e no drag horizontal
  void _changeDateValue(double dragAmount) {
    final int change = dragAmount > 20 ? -1 : (dragAmount < -20 ? 1 : 0);

    if (change == 0) {
      return;
    }

    // Resetar o valor do drag após aplicar a mudança
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

  // Obter valor anterior baseado no componente ativo (sem restrições para visualização)
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

    // Não exibir se estiver fora dos limites permitidos
    if (firstDate != null && previousDate.isBefore(firstDate!)) {
      return selectedDate;
    }
    if (lastDate != null && previousDate.isAfter(lastDate!)) {
      return selectedDate;
    }

    return previousDate;
  }

  // Obter próximo valor baseado no componente ativo (sem restrições para visualização)
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

    // Não exibir se estiver fora dos limites permitidos
    if (firstDate != null && nextDate.isBefore(firstDate!)) {
      return selectedDate;
    }
    if (lastDate != null && nextDate.isAfter(lastDate!)) {
      return selectedDate;
    }

    return nextDate;
  }

  // Obter valor formatado para exibição
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

  // Obter tamanho da fonte baseado no componente ativo
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
