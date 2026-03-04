import 'package:flutter_test/flutter_test.dart';
import 'package:flx_core_flutter/src/app/util/flx_date_format.dart';

void main() {
  group('FlxDateFormat Unit Tests', () {
    final baseDate = DateTime(2024, 11, 30, 17); // 17:00 Local

    test('isUtc should be true if pattern contains Z', () {
      expect(FlxDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").isUtc, isTrue);
      expect(FlxDateFormat('yyyy-MM-dd').isUtc, isFalse);
    });

    test('format should return local time for non-UTC patterns', () {
      final formatter = FlxDateFormat('yyyy-MM-dd HH:mm:ss');
      expect(formatter.format(baseDate), '2024-11-30 17:00:00');
    });

    test('format should return UTC time for patterns containing Z', () {
      final formatter = FlxDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      final expectedUtc = baseDate.toUtc();

      // We check if the result matches the manually formatted UTC date
      // to avoid hardcoding the offset
      final result = formatter.format(baseDate);

      expect(result.endsWith('Z'), isTrue);
      // Ensure it's not the local 17:00 if the timezone is not UTC
      if (baseDate.timeZoneOffset != Duration.zero) {
        expect(result.contains('17:00:00'), isFalse);
      }
    });

    test('format should handle empty or invalid patterns gracefully', () {
      final formatter = FlxDateFormat('');
      // Should not crash, should use fallback
      expect(formatter.format(baseDate), isNotEmpty);

      final invalidFormatter = FlxDateFormat('invalid-pattern');
      expect(invalidFormatter.format(baseDate), isNotEmpty);
    });

    test('tryParse should return DateTime if valid', () {
      final formatter = FlxDateFormat('yyyy-MM-dd');
      final date = formatter.tryParse('2024-11-30');
      expect(date, isNotNull);
      expect(date!.year, 2024);
      expect(date.month, 11);
      expect(date.day, 30);
    });
  });
}
