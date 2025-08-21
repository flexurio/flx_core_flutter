import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class TColumn<T> {
  TColumn({
    required this.title,
    required this.builder,
    this.numeric = false,
  });

  final String title;
  final bool numeric;
  final String Function(T data, int index) builder;
}

List<int> simpleExcel<T>({
  required BuildContext context,
  required List<T> data,
  required List<TColumn<T>> columns,
}) {
  final theme = Theme.of(context);
  final primaryColor = theme.colorScheme.primary;

  final workbook = Workbook();
  final sheet = workbook.worksheets[0];

  final headers = columns.map((e) => e.title).toList();
  final columnsCount = columns.length;

  sheet.getRangeByIndex(1, 1, 1, headers.length)
    ..cellStyle.backColorRgb = primaryColor
    ..cellStyle.fontColor = '#FFFFFF'
    ..cellStyle.bold = true
    ..cellStyle.fontName
    ..cellStyle.fontSize = 14;

  for (var i = 0; i < headers.length; i++) {
    final cell = sheet.getRangeByIndex(1, i + 1)..setValue(headers[i]);
    if (columns[i].numeric) {
      cell.cellStyle.hAlign = HAlignType.right;
    }
  }

  for (var i = 0; i < headers.length; i++) {
    sheet
      ..autoFitColumn(1 + i)
      ..autoFitRow(1);
  }

  for (var row = 0; row < data.length; row++) {
    final item = data[row];

    for (var col = 0; col < columnsCount; col++) {
      final column = columns[col];
      final cell = sheet.getRangeByIndex(row + 2, col + 1)
        ..setValue(column.builder(item, row))
        ..cellStyle.backColorRgb = (row + 2).isEven
            ? primaryColor.lighten(.25)
            : primaryColor.lighten(.3);
      if (columns[col].numeric) {
        cell.cellStyle.hAlign = HAlignType.right;
      }
    }
  }

  for (var i = 0; i < headers.length; i++) {
    sheet
      ..autoFitColumn(1 + i)
      ..autoFitRow(1);
  }

  final bytes = workbook.saveSync();
  return bytes;
}

List<int> generalXlsx(
  BuildContext context,
  List<Map<String, dynamic>> data,
  List<String> fields,
) {
  for (final field in fields) {
    if (!data[0].containsKey(field)) {
      throw Exception(
        'The specified field "$field" is missing from the data. '
        'Available fields are: ${data[0].keys.join(', ')}.',
      );
    }
  }

  final columns = <TColumn<Map<String, dynamic>>>[];
  for (final field in fields) {
    final numeric = data.isNotEmpty && data[0][field] is num;
    columns.add(
      TColumn<Map<String, dynamic>>(
        numeric: numeric,
        title: field.replaceAll('_', ' ').toUpperCase(),
        builder: (data, index) => data.containsKey(field)
            ? (data[field]?.toString() ?? '-')
            : 'Error: Field "$field" not found',
      ),
    );
  }

  final bytes = simpleExcel<Map<String, dynamic>>(
    context: context,
    data: data,
    columns: columns,
  );
  return bytes;
}
