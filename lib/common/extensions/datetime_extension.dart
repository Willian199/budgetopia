import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  DateTime get firstDayOfMonth {
    return DateTime(year, month);
  }

  DateTime get lastDayOfMonth {
    return DateTime(year, month + 1, 0);
  }

  bool get isLastDayOfMonth {
    return this == lastDayOfMonth;
  }

  DateTime get minusSixMonth => subtractMonths(6);

  DateTime subtractMonths(int months) {
    int year = this.year;
    int month = this.month - months;
    while (month < 1) {
      month += 12;
      year--;
    }
    return DateTime(year, month, day, hour, minute, second, millisecond, microsecond);
  }

  String format({String formatString = 'dd/MM/yyyy'}) {
    final formatter = DateFormat(formatString);
    return formatter.format(this);
  }

  String getFormattedMonth() {
    return _getMonthName(month);
  }

  String _getMonthName(int month) {
    return switch (month) {
      1 => 'Jan',
      2 => 'Fev',
      3 => 'Mar',
      4 => 'Abr',
      5 => 'Mai',
      6 => 'Jun',
      7 => 'Jul',
      8 => 'Ago',
      9 => 'Set',
      10 => 'Out',
      11 => 'Nov',
      12 => 'Dez',
      _ => ''
    };
  }
}
