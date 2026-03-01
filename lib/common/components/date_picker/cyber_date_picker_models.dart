/// Enum representing the date components that can be edited.
///
/// Used in selector mode to track which component (day, month, or year)
/// is currently active/focused.
enum CyberDateComponent {
  /// Day component (1-31)
  day,

  /// Month component (1-12)
  month,

  /// Year component
  year,
}

/// Enum representing the two input modes of the date picker.
///
/// - [selector]: Horizontal swipe gestures to adjust values
/// - [input]: Direct text input with DD/MM/YYYY format
enum CyberDatePickerMode {
  /// Gesture-based selector mode with swipe controls.
  selector,

  /// Text input mode with DD/MM/YYYY fields.
  input,
}

/// Constants used throughout the CyberDatePicker component.
///
/// This class provides month names and date range constraints
/// for validation and display purposes.
class CyberDatePickerConstants {
  /// Month names abbreviated to 3 characters for display.
  ///
  /// Index corresponds to month number minus 1 (0-indexed).
  static const List<String> months = [
    'JAN',
    'FEV',
    'MAR',
    'ABR',
    'MAI',
    'JUN',
    'JUL',
    'AGO',
    'SET',
    'OUT',
    'NOV',
    'DEZ',
  ];

  /// The minimum allowed year for date selection.
  static const int minYear = 1900;

  /// The maximum allowed year for date selection.
  static const int maxYear = 2100;
}
