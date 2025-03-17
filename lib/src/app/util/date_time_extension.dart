import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  bool get isWeekend {
    final weekday = this.weekday;
    return [7, 6].contains(weekday);
  }

  String get yMMMdHm {
    return DateFormat.yMMMd().add_Hm().format(this);
  }

  String get yMMMd {
    return DateFormat.yMMMd().format(this);
  }

  String get yMMMMd {
    return DateFormat.yMMMMd().format(this);
  }

  String get yMMMM {
    return DateFormat.yMMMM().format(this);
  }

  String get yyyyMMddDash {
    return DateFormat('yyyy-MM-dd').format(this);
  }

    String get yyyyMMdd {
    return DateFormat('yyyyMMdd').format(this);
  }

  String get yyyyMM {
    return DateFormat('yyyyMM').format(this);
  }

  String get formatMMMyy {
    return DateFormat('MMM yy').format(this);
  }

  String get ddMMyyyy {
    return DateFormat('dd-MM-yyyy').format(this);
  }

  String get ddMMyyyyHHmmDash {
    return DateFormat('dd-MM-yyyy HH:mm').format(this);
  }

  String get ddMMMMy {
    return DateFormat('dd MMMM y').format(this);
  }

  String get ddMMyyyySlash {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  DateTime get endOfDay {
    return DateTime(year, month, day + 1)
        .subtract(const Duration(milliseconds: 1));
  }

  DateTime get startOfMonth {
    return DateTime(year, month);
  }

  DateTime get endOfMonth {
    return DateTime(year, month + 1).subtract(const Duration(days: 1));
  }

  String toUtcIso() {
    return toUtc().toIso8601String();
  }
}
