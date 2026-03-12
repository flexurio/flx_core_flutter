import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/table_column.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/yuhu_table.dart';
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down.dart';

void main() {
  group('YuhuTable', () {
    final testData = <Map<String, dynamic>>[
      {'id': 1, 'name': 'Alice', 'age': 30},
      {'id': 2, 'name': 'Bob', 'age': 25},
    ];

    List<TableColumn<Map<String, dynamic>>> testColumns() {
      return [
        TableColumn<Map<String, dynamic>>(
          title: 'ID',
          builder: (item, index) => Text(item['id'].toString()),
        ),
        TableColumn<Map<String, dynamic>>(
          title: 'Name',
          builder: (item, index) => Text(item['name'] as String),
        ),
        TableColumn<Map<String, dynamic>>(
          title: 'Age',
          builder: (item, index) => Text(item['age'].toString()),
        ),
      ];
    }

    Widget createTestWidget({
      List<Map<String, dynamic>>? data,
      List<TableColumn<Map<String, dynamic>>>? columns,
      Status status = Status.loaded,
      void Function(int, bool)? onSort,
      void Function(List<Map<String, dynamic>>)? onSelectChanged,
      bool freezeFirstColumn = false,
      bool freezeLastColumn = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 800,
            height: 600,
            child: YuhuTable<Map<String, dynamic>>(
              data: data ?? testData,
              columns: columns ?? testColumns(),
              status: status,
              onSort: onSort,
              onSelectChanged: onSelectChanged,
              freezeFirstColumn: freezeFirstColumn,
              freezeLastColumn: freezeLastColumn,
            ),
          ),
        ),
      );
    }

    testWidgets('renders basic table with columns and data', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should find headers
      expect(find.text('ID'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);

      // Should find data rows
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
    });

    testWidgets('renders progress indicator when status is progress',
        (tester) async {
      await tester.pumpWidget(createTestWidget(status: Status.progress));
      await tester.pump();

      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    });

    testWidgets('renders error icon when status is error', (tester) async {
      await tester.pumpWidget(createTestWidget(status: Status.error));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('triggers onSort when a header is tapped', (tester) async {
      int? sortedCol;
      bool? isAscending;

      await tester.pumpWidget(createTestWidget(
        onSort: (col, asc) {
          sortedCol = col;
          isAscending = asc;
        },
      ),);
      await tester.pumpAndSettle();

      // Tap the 'Name' column header (index 1) which is represented by TableHeader
      final headers = find.byWidgetPredicate(
          (w) => w.runtimeType.toString().contains('TableHeader'),);

      // Tap the InkWell inside the second header (index 1 corresponds to 'Name')
      final headerInkWell = find
          .descendant(of: headers.at(1), matching: find.byType(InkWell))
          .first;

      final inkWellWidget = tester.widget<InkWell>(headerInkWell);
      inkWellWidget.onTap?.call();

      await tester.pumpAndSettle();

      expect(sortedCol, 1);
      // Depending on initial state, default ascending is true, so first click with no strict text sort returns false.
      expect(isAscending, false);
    });

    testWidgets('triggers onSelectChanged when checkbox is checked',
        (tester) async {
      List<Map<String, dynamic>>? selectedItems;

      await tester.pumpWidget(createTestWidget(
        onSelectChanged: (items) {
          selectedItems = items;
        },
      ),);
      await tester.pumpAndSettle();

      // Checkboxes exist because onSelectChanged was provided
      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(2));

      // Tap the first row's checkbox
      await tester.tap(checkboxes.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(selectedItems, isNotNull);
      expect(selectedItems!.length, 1);
      expect(selectedItems!.first['name'], 'Alice');
    });

    testWidgets('renders pinned columns correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(
        freezeFirstColumn: true,
        freezeLastColumn: true,
      ),);
      await tester.pumpAndSettle();

      expect(find.text('ID'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
    });
  });
}
