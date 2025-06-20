import 'package:intl/intl.dart';

NumberFormat formatterIdr = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'IDR ',
  decimalDigits: 2,
);

extension NumExtension on num {
  String get idr {
    return formatterIdr.format(this);
  }

  String get compact {
    return NumberFormat.compact().format(this);
  }

  String format([int decimalDigits = 2]) {
    return NumberFormat.currency(
      symbol: '',
      decimalDigits: decimalDigits,
    ).format(this);
  }

  String formatWithSymbol() {
    return '${isNegative ? '' : '+'}${format()}';
  }

  // to negative
  num toNegative() {
    return this * -1;
  }

  String thousandSeparator() {
    return NumberFormat.decimalPattern('id').format(this);
  }
}
