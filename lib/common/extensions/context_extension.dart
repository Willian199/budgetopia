import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

extension AdaptiveThemeExtensions on BuildContext {
  ThemeData get theme => AdaptiveTheme.of(this).theme;

  ColorScheme get colorScheme => theme.colorScheme;

  void closeKeyboard() {
    final FocusScopeNode currentFocus = FocusScope.of(this);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
