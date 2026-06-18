import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

void main() {
  group('Responsive UI Tests', () {
    testWidgets('SingleFormPanel should respect customWidth', (tester) async {
      tester.view.physicalSize = const Size(2000, 1000);
      tester.view.devicePixelRatio = 1.0;

      const customWidth = 1100.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleFormPanel(
              customWidth: customWidth,
              action: DataAction.create,
              entity: const Entity(titleX: 'test', subtitleX: 'test', iconPath: ''),
              children: const [Text('Content')],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(SingleFormPanel),
          matching: find.byType(Container),
        ).first,
      );

      final constraints = container.constraints;
      expect(constraints?.maxWidth, customWidth);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('SingleFormPanel should use dynamic default width on large screens', (tester) async {
      tester.view.physicalSize = const Size(2000, 1000);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleFormPanel(
              action: DataAction.create,
              entity: const Entity(titleX: 'test', subtitleX: 'test', iconPath: ''),
              children: const [Text('Content')],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(SingleFormPanel),
          matching: find.byType(Container),
        ).first,
      );

      final maxWidth = container.constraints?.maxWidth;
      expect(maxWidth, 1400.0);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('CardForm (popup) should respect width but cap at screen size', (tester) async {
      tester.view.physicalSize = const Size(500, 1000);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => const CardForm(
                        popup: true,
                        width: 800,
                        title: 'Test',
                        icon: Icons.info,
                        actions: [],
                        child: Text('Content'),
                      ),
                    );
                  },
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(SimpleDialog),
          matching: find.byType(Container),
        ).first,
      );

      final maxWidth = container.constraints?.maxWidth;
      expect(maxWidth, 475.0);

      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}
