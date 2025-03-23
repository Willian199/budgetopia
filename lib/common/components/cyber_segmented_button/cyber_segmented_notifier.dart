import 'package:flutter/material.dart';

class CyberSegmentItem<T> {
  CyberSegmentItem({
    required this.value,
    required this.label,
  });
  final T value;
  final Widget label;
}

class SegmentedButtonModel<T> extends ChangeNotifier {
  // Índice do item selecionado
  int _selectedIndex = 0;

  // Getter para o índice selecionado
  int get selectedIndex => _selectedIndex;

  // Método para atualizar o índice selecionado
  void updateSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  // Método para atualizar o índice com base no valor selecionado
  void updateFromValue(Set<T> selected, List<CyberSegmentItem<T>> segments) {
    if (selected.isEmpty) {
      _selectedIndex = 0;
      return;
    }

    final T selectedValue = selected.first;
    for (int i = 0; i < segments.length; i++) {
      if (segments[i].value == selectedValue) {
        if (_selectedIndex != i) {
          _selectedIndex = i;
          notifyListeners();
        }
        break;
      }
    }
  }
}
