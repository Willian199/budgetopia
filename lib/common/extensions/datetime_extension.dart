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

  String format({String formatString = 'dd/MM/yyyy'}) {
    final formatter = DateFormat(formatString);
    return formatter.format(this);
  }
}
