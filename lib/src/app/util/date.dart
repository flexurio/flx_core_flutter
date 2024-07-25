import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime isoDateToDateTime(String? date) {
  if (date == null || date == '') {
    return DateTime.now();
  } else {
    return DateTime.parse(date).toLocal();
  }
}

DateTime periodFromJson(String period) {
  final now = DateTime.now();
  try {
    final year = int.parse(period.substring(0, 4));
    final month = int.parse(period.substring(4, 6));
    return DateTime(year, month);
  } catch (e) {
    return DateTime(now.year, now.month);
  }
}

DateTime? dateTimeNullable(String? dateTime) {
  if (dateTime == null || dateTime == '') {
    return null;
  } else {
    return DateTime.parse(dateTime).toLocal();
  }
}

DateTime? dateTimeNullableFromJson(String? dateTime) {
  if (dateTime == null) return null;
  return DateTime.parse(dateTime).toLocal();
}

DateTime dateTimeFromJson(String dateTime) {
  return DateTime.parse(dateTime).toLocal();
}

String dateFormatUsToPeriodMonth(String string) {
  return DateFormat('yyyyMMdd')
      .format(DateFormat.yMMMMd('en_US').parse(string));
}

String periodMonthToDateFormatUs(String string) {
  final dateTime = DateTime.parse(
    '${string.substring(0, 4)}-'
    '${string.substring(4, 6)}-'
    '${string.substring(6, 8)}',
  );
  return DateFormat.yMMMMd('en_US').format(dateTime);
}

extension TimeOfDayExtension on TimeOfDay {
  String get toTime {
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }
}
