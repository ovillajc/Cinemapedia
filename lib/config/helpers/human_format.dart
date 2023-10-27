import 'package:intl/intl.dart';

// Clase que transforma las cantidades a una mas legible basado en social networks
class HumanFormats {
  static String number(double number) {
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
      locale: 'en',
    ).format(number);

    return formattedNumber;
  }
}
