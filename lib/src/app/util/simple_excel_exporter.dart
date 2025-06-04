import 'package:excel/excel.dart';
import 'package:flx_core_flutter/src/app/util/pdf.dart';

class SimpleExcelExporter<T> {
  SimpleExcelExporter({
    required this.data,
    required this.headers,
    required this.body,
    required this.title,
    required this.printedBy,
  }) {
    _excel = Excel.createExcel();
    _sheet = _excel['Sheet1'];
  }

  final List<T> data;
  final List<PColumnHeader> headers;
  final List<PColumnBody<T>> body;
  final String title;
  final String printedBy;

  late final Excel _excel;
  late final Sheet _sheet;

  List<int> export() {
    final hasChildren = headers.any((e) => e.children?.isNotEmpty ?? false);
    final dataStartRow = hasChildren ? 4 : 3;

    final border = _thinBorder();
    final headerStyle = _headerCellStyle(border);
    final evenStyle = _rowCellStyle(border, ExcelColor.lightBlue50);
    final oddStyle = _rowCellStyle(border, ExcelColor.lightBlue100);
    final infoStyle = _infoStyle();

    _renderTitleAndInfo(infoStyle);
    hasChildren
        ? _renderHeadersWithChildren(headerStyle)
        : _renderHeaders(headerStyle);
    _renderData(dataStartRow, evenStyle, oddStyle);
    _autoFitColumns();

    return _excel.encode()!;
  }

  // ==== PRIVATE METHODS ====

  void _renderTitleAndInfo(CellStyle style) {
    _sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
      ..value = TextCellValue(title)
      ..cellStyle = style;

    _sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
      ..value = TextCellValue('Printed by: $printedBy')
      ..cellStyle = style;
  }

  void _renderHeadersWithChildren(CellStyle style) {
    var colIndex = 0;
    for (final header in headers) {
      final hasChildren = header.children?.isNotEmpty ?? false;

      if (hasChildren) {
        final children = header.children!;
        final span = children.length;

        _sheet.merge(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 2),
          CellIndex.indexByColumnRow(
              columnIndex: colIndex + span - 1, rowIndex: 2),
        );

        _sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 2))
          ..value = TextCellValue(header.title)
          ..cellStyle = style;

        for (var i = 0; i < span; i++) {
          _sheet.cell(CellIndex.indexByColumnRow(
              columnIndex: colIndex + i, rowIndex: 3))
            ..value = TextCellValue(children[i].title)
            ..cellStyle = style;
        }

        colIndex += span;
      } else {
        _sheet.merge(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 2),
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 3),
        );

        _sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 2))
          ..value = TextCellValue(header.title)
          ..cellStyle = style;

        colIndex++;
      }
    }
  }

  void _renderHeaders(CellStyle style) {
    for (var col = 0; col < headers.length; col++) {
      _sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 2))
        ..value = TextCellValue(headers[col].title)
        ..cellStyle = style;
    }
  }

  void _renderData(int startRow, CellStyle evenStyle, CellStyle oddStyle) {
    for (var row = 0; row < data.length; row++) {
      final item = data[row];
      final rowStyle = row.isEven ? evenStyle : oddStyle;

      for (var col = 0; col < body.length; col++) {
        final column = body[col];
        final value = column.contentBuilder(item, row);

        final cell = _sheet.cell(
          CellIndex.indexByColumnRow(
              columnIndex: col, rowIndex: startRow + row),
        )..value = TextCellValue(value);

        cell.cellStyle = rowStyle.copyWith(
          horizontalAlignVal:
              column.numeric ? HorizontalAlign.Right : HorizontalAlign.Left,
        );
      }
    }
  }

  void _autoFitColumns() {
    final rowCount = data.length;

    for (var col = 0; col < body.length; col++) {
      int maxLength = 0;

      final headerTitle = headers.length > col ? headers[col].title : '';
      maxLength = headerTitle.length;

      for (var row = 0; row < rowCount; row++) {
        final value = body[col].contentBuilder(data[row], row);
        if (value.length > maxLength) {
          maxLength = value.length;
        }
      }

      _sheet.setColumnWidth(col, maxLength.toDouble() + 2); // +2 padding
    }
  }

  // ==== STYLES ====

  Border _thinBorder() => Border(
        borderStyle: BorderStyle.Thin,
        borderColorHex: ExcelColor.black,
      );

  CellStyle _headerCellStyle(Border border) => CellStyle(
        bold: true,
        fontColorHex: ExcelColor.white,
        backgroundColorHex: ExcelColor.lightBlue,
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        bottomBorder: border,
        topBorder: border,
        leftBorder: border,
        rightBorder: border,
      );

  CellStyle _rowCellStyle(Border border, ExcelColor backgroundColor) =>
      CellStyle(
        backgroundColorHex: backgroundColor,
        bottomBorder: border,
        topBorder: border,
        leftBorder: border,
        rightBorder: border,
      );

  CellStyle _infoStyle() => CellStyle(
        bold: true,
        fontColorHex: ExcelColor.black,
        horizontalAlign: HorizontalAlign.Left,
        verticalAlign: VerticalAlign.Center,
      );
}
