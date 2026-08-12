import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

void main() {
  group('CardForm Tests', () {
    testWidgets('should hide actions container if actions list is empty',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CardForm(
              title: 'Test',
              icon: Icons.info,
              actions: [],
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(
          find.byType(Row), findsOneWidget); // Only the title Row should exist
    });

    testWidgets('should show actions container if actions list is NOT empty',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CardForm(
              title: 'Test',
              icon: Icons.info,
              actions: [Text('Action 1')],
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.text('Action 1'), findsOneWidget);
      expect(find.byType(Row), findsNWidgets(2)); // Title Row and Actions Row
    });

    testWidgets('should show close button X when popup is true',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CardForm(
              popup: true,
              title: 'Test Popup',
              icon: Icons.info,
              actions: [],
              child: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should call onClose callback when close button X is tapped',
        (tester) async {
      var closed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CardForm(
              popup: true,
              title: 'Test Popup',
              icon: Icons.info,
              actions: const [],
              onClose: () => closed = true,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      expect(closed, isTrue);
    });
    group('SingleFormPanel Tests', () {
      testWidgets('should hide actions row if actions list is empty',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleFormPanel(
                action: DataAction.create,
                entity: Entity(titleX: 'test', subtitleX: 'test', iconPath: ''),
                actions: [],
                children: [Text('Content')],
              ),
            ),
          ),
        );

        expect(find.byType(RowFields), findsNothing);
      });

      testWidgets('should show actions row if actions list is NOT empty',
          (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SingleFormPanel(
                action: DataAction.create,
                entity: Entity(titleX: 'test', subtitleX: 'test', iconPath: ''),
                actions: [Text('Action 1')],
                children: [Text('Content')],
              ),
            ),
          ),
        );

        expect(find.byType(RowFields), findsOneWidget);
        expect(find.text('Action 1'), findsOneWidget);
      });
    });
  });
}
