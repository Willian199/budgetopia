import 'package:budgetopia/common/constantes/strings.dart';
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

  String format({String formatString = Strings.DATA_FORMATO_PADRAO}) {
    final formatter = DateFormat(formatString);
    return formatter.format(this);
  }

  String getFormattedMonth() {
    return _getMonthName(month);
  }

  String _getMonthName(int month) {
    return month >= 1 && month < Strings.MESES_CURTOS.length ? Strings.MESES_CURTOS[month] : '';
  }
}
