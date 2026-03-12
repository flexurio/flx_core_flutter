import 'package:intl/intl.dart';

/// A utility class to handle date formatting with smart UTC conversion.
class FlxDateFormat {
  FlxDateFormat(this.pattern);
  final String pattern;

  /// Checks if the pattern implies a UTC format (contains 'Z').
  bool get isUtc => pattern.contains('Z');

  /// Formats a [DateTime] based on the pattern.
  /// Automatically converts to UTC if the pattern indicates it.
  String format(DateTime date) {
    if (pattern.isEmpty) return DateFormat.yMMMMd().format(date);

    try {
      final dateToFormat = isUtc ? date.toUtc() : date;
      return DateFormat(pattern).format(dateToFormat);
    } catch (e) {
      // Fallback to default format if pattern is invalid
      return DateFormat.yMMMMd().format(date);
    }
  }

  /// Attempts to parse a string value back into a [DateTime].
  DateTime? tryParse(String value) {
    if (value.isEmpty) return null;
    try {
      return DateFormat(pattern).parse(value);
    } catch (e) {
      return DateTime.tryParse(value);
    }
  }
}
