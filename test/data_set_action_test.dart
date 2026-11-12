import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/view/widget/data_set_action.dart';

Widget _buildTestWidget() {
  return MaterialApp(
    home: Scaffold(
      body: DataSetAction<Map<String, dynamic>>(
        status: Status.loaded,
        pageOptions: PageOptions<Map<String, dynamic>>.empty(),
        onChanged: (_) {},
        onRefresh: () {},
        actionLeft: const [
          SizedBox(width: 160, height: 32, child: Text('Period')),
          SizedBox(width: 190, height: 32, child: Text('Status')),
          SizedBox(width: 220, height: 32, child: Text('LBB Category')),
          SizedBox(width: 215, height: 32, child: Text('LBB Type')),
        ],
        actionRight: (refresh) => [
          const SizedBox(width: 80, height: 32, child: Text('Filter')),
          refresh,
          const SizedBox(width: 80, height: 32, child: Text('Add')),
        ],
        child: const SizedBox(height: 100),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'DataSetAction keeps 4 filters on top row and actions below at 1000px',
    (tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final periodTop = tester.getTopLeft(find.text('Period')).dy;
      final periodBottom = tester.getBottomLeft(find.text('Period')).dy;
      final typeTop = tester.getTopLeft(find.text('LBB Type')).dy;
      final filterTop = tester.getTopLeft(find.text('Filter')).dy;

      expect(typeTop, equals(periodTop));
      expect(filterTop, greaterThan(periodBottom));
    },
  );

  testWidgets(
    'DataSetAction places 4 filters and actions on one row at 1250px',
    (tester) async {
      tester.view.physicalSize = const Size(1250, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final periodTop = tester.getTopLeft(find.text('Period')).dy;
      final periodBottom = tester.getBottomLeft(find.text('Period')).dy;
      final typeTop = tester.getTopLeft(find.text('LBB Type')).dy;
      final filterTop = tester.getTopLeft(find.text('Filter')).dy;

      expect(typeTop, equals(periodTop));
      expect(filterTop, lessThan(periodBottom));
    },
  );

  testWidgets(
    'DataSetAction wraps filters cleanly without overflow at 650px',
    (tester) async {
      tester.view.physicalSize = const Size(650, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );
}
