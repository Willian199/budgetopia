import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// Theme for the Cyberpunk Date Picker
extension CyberDatePickerTheme on BuildContext {
  // Main color scheme
  Color get primaryColor => isDark ? theme.colorScheme.secondaryContainer : theme.colorScheme.primary;
  Color get accentColor => theme.colorScheme.secondary;
  Color get backgroundColor => theme.colorScheme.onPrimary;
  Color get secondaryBackgroundColor => theme.colorScheme.onTertiary;

  // Text styles
  TextStyle valueTextStyle({
    required double fontSize,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color ?? accentColor,
    );
  }

  TextStyle valueOutlineTextStyle({
    required double fontSize,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = accentColor,
    );
  }

  TextStyle componentButtonTextStyle({
    required bool isActive,
  }) {
    return TextStyle(
      color: isActive ? Colors.white : accentColor,
      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      fontSize: 14,
    );
  }

  TextStyle instructionTextStyle() {
    return TextStyle(
      color: accentColor,
      fontSize: 12,
    );
  }

  TextStyle dateDisplayTextStyle() {
    return TextStyle(
      color: accentColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  // Decorations
  BoxDecoration backgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          backgroundColor,
          secondaryBackgroundColor.withValues(alpha: 0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  BoxDecoration componentButtonDecoration({
    required bool isActive,
  }) {
    return BoxDecoration(
      color: isActive ? primaryColor : backgroundColor,
      border: Border.all(color: accentColor),
      borderRadius: BorderRadius.circular(4),
    );
  }

  BoxDecoration dateDisplayDecoration() {
    return BoxDecoration(
      border: Border.all(color: primaryColor),
      borderRadius: BorderRadius.circular(5),
    );
  }

  // Button style
  ButtonStyle confirmButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // Input decoration
  InputDecoration dateInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: accentColor.withValues(alpha: 0.5),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: accentColor, width: 3),
      ),
    );
  }
}
