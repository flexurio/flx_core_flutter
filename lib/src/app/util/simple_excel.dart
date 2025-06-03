import 'package:excel/excel.dart' as ex;
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

List<int> simpleExcel2<T>({
  required List<T> data,
  required List<PColumnHeader> header,
  required List<PColumnBody<T>> body,
  required String title,
}) {
  final excel = ex.Excel.createExcel();
  final sheet = excel['Sheet1'];
  final headerHasChildren = header.any((e) => e.children?.isNotEmpty ?? false);
  final border = ex.Border(
    borderStyle: ex.BorderStyle.Thin,
    borderColorHex: ex.ExcelColor.black,
  );

  final headerStyle = ex.CellStyle(
    bold: true,
    fontColorHex: ex.ExcelColor.white,
    backgroundColorHex: ex.ExcelColor.lightBlue,
    horizontalAlign: ex.HorizontalAlign.Center,
    verticalAlign: ex.VerticalAlign.Center,
    bottomBorder: border,
    topBorder: border,
    leftBorder: border,
    rightBorder: border,
  );

  final rowStyleEven = ex.CellStyle(
    backgroundColorHex: ex.ExcelColor.lightBlue50,
    bottomBorder: border,
    topBorder: border,
    leftBorder: border,
    rightBorder: border,
  );

  final rowStyleOdd = ex.CellStyle(
    backgroundColorHex: ex.ExcelColor.lightBlue100,
    bottomBorder: border,
    topBorder: border,
    leftBorder: border,
    rightBorder: border,
  );

  // ----- HEADER -----
  int colIndex = 0;
  for (var h in header) {
    final hasChildren = h.children?.isNotEmpty ?? false;
    if (hasChildren) {
      final children = h.children!;
      final childCount = children.length;

      // Merge parent title across child columns
      sheet.merge(
        ex.CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 0),
        ex.CellIndex.indexByColumnRow(
            columnIndex: colIndex + childCount - 1, rowIndex: 0),
      );

      final parentCell = sheet.cell(
          ex.CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 0));
      parentCell.value = ex.TextCellValue(h.title);
      parentCell.cellStyle = headerStyle;

      // Render child titles in row 1
      for (var i = 0; i < childCount; i++) {
        final child = children[i];
        final cell = sheet.cell(ex.CellIndex.indexByColumnRow(
            columnIndex: colIndex + i, rowIndex: 1));
        cell.value = ex.TextCellValue(child.title);
        cell.cellStyle = headerStyle;
      }

      colIndex += childCount;
    } else {
      // Merge vertically across 2 rows
      sheet.merge(
        ex.CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 0),
        ex.CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 1),
      );

      final cell = sheet.cell(
          ex.CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 0));
      cell.value = ex.TextCellValue(h.title);
      cell.cellStyle = headerStyle;

      colIndex += 1;
    }
  }

  // ----- DATA -----
  final dataStartRow = headerHasChildren ? 2 : 1;

  for (var row = 0; row < data.length; row++) {
    final item = data[row];
    final isEvenRow = row % 2 == 0;

    for (var col = 0; col < body.length; col++) {
      final column = body[col];
      final value = column.contentBuilder(item, row);
      final cell = sheet.cell(ex.CellIndex.indexByColumnRow(
          columnIndex: col, rowIndex: dataStartRow + row));
      cell.value = ex.TextCellValue(value.toString());

      final baseStyle = isEvenRow ? rowStyleEven : rowStyleOdd;

      // Alignment
      if (column.numeric) {
        cell.cellStyle =
            baseStyle.copyWith(horizontalAlignVal: ex.HorizontalAlign.Right);
      } else {
        cell.cellStyle =
            baseStyle.copyWith(horizontalAlignVal: ex.HorizontalAlign.Left);
      }
    }
  }

  for (var col = 0; col < body.length; col++) {
    sheet.setColumnAutoFit(col);
  }

  final fileBytes = excel.encode()!;
  return fileBytes;
}
