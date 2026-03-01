// Enums for the date picker
enum CyberDateComponent { day, month, year }

// Enum for the picker modes
enum CyberDatePickerMode { selector, input }

// Constants
class CyberDatePickerConstants {
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

  static const int minYear = 1900;
  static const int maxYear = 2100;
}
