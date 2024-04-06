import 'package:intl/intl.dart';

class Moeda {
  static String format({required double valor, String? simbolo, int? decimalDigits}) {
    final NumberFormat format = NumberFormat.currency(
      symbol: simbolo ?? "",
      decimalDigits: decimalDigits ?? 2,
      locale: 'pt',
    );
    return format.format(valor);
  }

  static num parse({required String valor, String? simbolo, int? decimalDigits}) {
    final NumberFormat format = NumberFormat.currency(
      symbol: simbolo ?? "",
      decimalDigits: decimalDigits ?? 2,
      locale: 'pt',
    );
    return format.parse(valor);
  }
}
