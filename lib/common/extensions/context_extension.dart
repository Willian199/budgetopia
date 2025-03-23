import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

extension AdaptiveThemeExtensions on BuildContext {
  ThemeData get theme => AdaptiveTheme.of(this).theme;

  bool get isDark => AdaptiveTheme.of(this).mode == AdaptiveThemeMode.dark;

  ColorScheme get colorScheme => theme.colorScheme;

  void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
