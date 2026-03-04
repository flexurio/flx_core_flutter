import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flx_core_flutter/src/app/view/widget/field_date_picker.dart';
import 'package:intl/intl.dart';

void main() {
  group('FieldDatePicker UTC Conversion Test', () {
    testWidgets('Should format local time when dateFormat does not contain Z',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      final localDate = DateTime(2024, 11, 30, 17, 0, 0); // 17:00 Local

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FieldDatePicker(
              controller: controller,
              initialSelectedDate: localDate,
              dateFormat: 'yyyy-MM-dd HH:mm:ss',
            ),
          ),
        ),
      );

      // Should match local time exactly
      expect(controller.text, '2024-11-30 17:00:00');
    });

    testWidgets(
        'Should automatically convert to UTC when dateFormat contains Z',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      // Use a fixed local date
      final localDate = DateTime(2024, 11, 30, 17, 0, 0);

      // Calculate expected UTC manually to be timezone independent in test
      final utcDate = localDate.toUtc();
      final expectedUtcString =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(utcDate);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FieldDatePicker(
              controller: controller,
              initialSelectedDate: localDate,
              dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            ),
          ),
        ),
      );

      // Controller should contain the UTC formatted string, not the local one
      expect(controller.text, expectedUtcString);

      expect(controller.text.contains('T'), isTrue);
      expect(controller.text.endsWith('Z'), isTrue);
    });
  });
}
