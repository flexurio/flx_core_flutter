import 'package:excel/excel.dart';
import 'package:flx_core_flutter/src/app/util/pdf.dart';
import 'package:flx_core_flutter/src/app/util/group_by.dart';

class SimpleExcelExporter<T> {
  SimpleExcelExporter({
    required this.data,
    required this.headers,
    required this.body,
    required this.title,
    required this.printedBy,
    this.group,
    this.footerBuilder,
    this.footerGroupBuilder,
  }) {
    _excel = Excel.createExcel();
    _sheet = _excel['Sheet1'];
  }

  final List<T> data;
  final List<PColumnHeader> headers;
  final List<PColumnBody<T>> body;
  final String title;
  final String printedBy;
  final String Function(T)? group;
  final List<PColumnFooter> Function(List<T> data)? footerBuilder;
  final List<PColumnFooter> Function(List<T> data)? footerGroupBuilder;

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
    if (group != null) {
      _renderGroupedData(startRow, evenStyle, oddStyle);
    } else {
      for (var row = 0; row < data.length; row++) {
        _renderRow(data[row], row, startRow + row, evenStyle, oddStyle);
      }
      if (footerBuilder != null) {
        _renderFooterRow(footerBuilder!(data), startRow + data.length);
      }
    }
  }

  void _renderGroupedData(
      int startRow, CellStyle evenStyle, CellStyle oddStyle) {
    final groupedData = groupBy<T>(data, group!);
    var currentRow = startRow;

    groupedData.forEach((groupKey, items) {
      _sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
        ..value = TextCellValue(groupKey)
        ..cellStyle = _groupHeaderStyle();
      currentRow++;

      for (var i = 0; i < items.length; i++) {
        _renderRow(items[i], i, currentRow, evenStyle, oddStyle);
        currentRow++;
      }

      if (footerGroupBuilder != null) {
        _renderFooterRow(footerGroupBuilder!(items), currentRow);
        currentRow++;
      }
    });

    if (footerBuilder != null) {
      _renderFooterRow(footerBuilder!(data), currentRow);
    }
  }

  void _renderRow(
      T item, int index, int rowIndex, CellStyle even, CellStyle odd) {
    final style = index.isEven ? even : odd;
    for (var col = 0; col < body.length; col++) {
      final column = body[col];
      final value = column.contentBuilder(item, index);
      final cell = _sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex));
      cell.value = TextCellValue(value);
      cell.cellStyle = style.copyWith(
        horizontalAlignVal:
            column.numeric ? HorizontalAlign.Right : HorizontalAlign.Left,
      );
    }
  }

  void _renderFooterRow(List<PColumnFooter> footers, int rowIndex) {
    int colIndex = 0;

    for (var footer in footers) {
      final flex = footer.flex ?? 1.0;
      final span = flex.ceil();

      if (span > 1) {
        _sheet.merge(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex),
          CellIndex.indexByColumnRow(
              columnIndex: colIndex + span - 1, rowIndex: rowIndex),
        );
      }

      final cell = _sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex),
      );
      cell.value = TextCellValue(footer.footer ?? '');
      cell.cellStyle = _footerStyle();

      colIndex += span;
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

      _sheet.setColumnWidth(col, maxLength.toDouble() + 2);
    }
  }

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

  CellStyle _groupHeaderStyle() => CellStyle(
        bold: true,
        fontColorHex: ExcelColor.blue800,
        horizontalAlign: HorizontalAlign.Left,
        verticalAlign: VerticalAlign.Center,
      );

  CellStyle _footerStyle() => CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.grey300,
        horizontalAlign: HorizontalAlign.Right,
        verticalAlign: VerticalAlign.Center,
      );
}
