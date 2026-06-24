import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flx_core_flutter/src/app/util/simple_excel.dart';

void main() {
  group('SimpleExcel Unit and Widget Tests', () {
    testWidgets('simpleExcel should process different data types without errors',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final testData = [
                  _TestData(
                    name: 'Product A',
                    price: 150000,
                    qty: 5,
                    isActive: true,
                    date: DateTime(2026, 6, 24),
                  ),
                  _TestData(
                    name: 'Product B',
                    price: 250000.5,
                    qty: 10,
                    isActive: false,
                    date: DateTime(2026, 6, 25),
                  ),
                ];

                final columns = [
                  TColumn<_TestData>(
                    title: 'Name',
                    builder: (data, index) => data.name,
                  ),
                  TColumn<_TestData>(
                    title: 'Price (num)',
                    numeric: true,
                    builder: (data, index) => data.price,
                  ),
                  TColumn<_TestData>(
                    title: 'Qty (String parsed to num)',
                    numeric: true,
                    builder: (data, index) => data.qty.toString(),
                  ),
                  TColumn<_TestData>(
                    title: 'Status (bool)',
                    builder: (data, index) => data.isActive,
                  ),
                  TColumn<_TestData>(
                    title: 'Date (DateTime)',
                    builder: (data, index) => data.date,
                  ),
                  TColumn<_TestData>(
                    title: 'Null value',
                    builder: (data, index) => null,
                  ),
                ];

                final bytes = simpleExcel<_TestData>(
                  context: context,
                  data: testData,
                  columns: columns,
                );

                expect(bytes, isNotEmpty);
                return const Text('Done');
              },
            ),
          ),
        ),
      );
    });

    testWidgets('generalXlsx should generate excel bytes from Map list',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final testData = [
                  {'product_name': 'A', 'stock': 10},
                  {'product_name': 'B', 'stock': 20},
                ];

                final bytes = generalXlsx(
                  context,
                  testData,
                  ['product_name', 'stock'],
                );

                expect(bytes, isNotEmpty);
                return const Text('Done');
              },
            ),
          ),
        ),
      );
    });
  });
}

class _TestData {
  _TestData({
    required this.name,
    required this.price,
    required this.qty,
    required this.isActive,
    required this.date,
  });

  final String name;
  final num price;
  final int qty;
  final bool isActive;
  final DateTime date;
}
