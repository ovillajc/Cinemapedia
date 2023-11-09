import 'package:intl/intl.dart';

// Clase que transforma las cantidades a una mas legible basado en social networks
class HumanFormats {
  static String number(double number, [int decimals = 0]) {
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en',
    ).format(number);

    return formattedNumber;
  }
}
