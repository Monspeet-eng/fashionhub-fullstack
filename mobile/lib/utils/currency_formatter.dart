import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _idrFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String formatIdr(num amount) {
    return _idrFormat.format(amount);
  }
}
