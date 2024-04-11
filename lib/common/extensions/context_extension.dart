import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

extension AdaptiveThemeExtensions on BuildContext {
  ThemeData get theme => AdaptiveTheme.of(this).theme;

  ColorScheme get colorScheme => theme.colorScheme;
}
