import 'package:excel/excel.dart';
import 'package:flx_core_flutter/src/app/util/group_by.dart';
import 'package:flx_core_flutter/src/app/util/pdf.dart';

class SimpleExcelExporter<T> {
  SimpleExcelExporter({
    required this.data,
    required this.headers,
    required this.body,
    required this.title,
    required this.printedBy,
    this.bodyFirstBuilder,
    this.group1,
    this.group2,
    this.footerBuilder,
    this.footerGroup1Builder,
    this.footerGroup2Builder,
  }) {
    _excel = Excel.createExcel();
    _sheet = _excel['Sheet1'];
  }

  final List<T> data;
  final List<PColumnHeader> headers;
  final List<PColumnBody<T>> body;
  final String title;
  final String printedBy;

  final String Function(T)? group1;
  final String Function(T)? group2;

  final List<PColumnBodyN<T>> Function(List<T> data)? bodyFirstBuilder;

  final List<List<PColumnFooter>> Function(List<T> data)? footerBuilder;
  final List<List<PColumnFooter>> Function(List<T> data)? footerGroup1Builder;
  final List<List<PColumnFooter>> Function(List<T> data)? footerGroup2Builder;

  late final Excel _excel;
  late final Sheet _sheet;

  List<int> export() {
    final hasChildren = headers.any((e) => e.children?.isNotEmpty ?? false);
    final dataStartRow = hasChildren ? 4 : 3;

    final headerStyle = _headerCellStyle();
    final evenStyle = _rowCellStyle(ExcelColor.lightBlue50);
    final oddStyle = _rowCellStyle(ExcelColor.lightBlue100);
    final infoStyle = _infoStyle();

    _renderTitleAndInfo(infoStyle);
    hasChildren
        ? _renderHeadersWithChildren(headerStyle)
        : _renderHeaders(headerStyle);
    _renderData(dataStartRow, evenStyle, oddStyle);
    _autoFitColumns();

    return _excel.encode()!;
  }

  void _renderData(int startRow, CellStyle evenStyle, CellStyle oddStyle) {
    if (group1 != null) {
      _renderGroupedData2Levels(startRow, evenStyle, oddStyle);
    } else {
      for (var row = 0; row < data.length; row++) {
        _renderRow(data[row], row, startRow + row, evenStyle, oddStyle);
      }
      if (footerBuilder != null) {
        _renderFooterRows(footerBuilder!(data), startRow + data.length);
      }
    }
  }

  void _renderGroupedData2Levels(
      int startRow, CellStyle evenStyle, CellStyle oddStyle) {
    final grouped1 = groupBy<T>(data, group1!);
    var currentRow = startRow;

    grouped1.forEach((key1, items1) {
      _sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
        ..value = TextCellValue('')
        ..cellStyle = CellStyle();
      currentRow++;

      _sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
        ..value = TextCellValue(key1)
        ..cellStyle = _groupHeaderStyle();
      currentRow++;

      if (group2 != null) {
        final grouped2 = groupBy<T>(items1, group2!);
        grouped2.forEach((key2, items2) {
          _sheet.cell(
              CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
            ..value = TextCellValue('')
            ..cellStyle = CellStyle();
          currentRow++;

          _sheet.cell(
              CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
            ..value = TextCellValue(key2)
            ..cellStyle = _groupSubHeaderStyle();
          currentRow++;

          if (bodyFirstBuilder != null) {
            final firstBodyCols = bodyFirstBuilder!(items2);
            _renderBodyFirstRow(firstBodyCols, currentRow);
            currentRow++;
          }

          for (var i = 0; i < items2.length; i++) {
            _renderRow(items2[i], i, currentRow, evenStyle, oddStyle);
            currentRow++;
          }

          if (footerGroup2Builder != null) {
            final rows = footerGroup2Builder!(items2);
            _renderFooterRows(rows, currentRow);
            currentRow += rows.length;
          }
        });
      } else {
        if (bodyFirstBuilder != null) {
          final firstBodyCols = bodyFirstBuilder!(items1);
          _renderBodyFirstRow(firstBodyCols, currentRow);
          currentRow++;
        }

        for (var i = 0; i < items1.length; i++) {
          _renderRow(items1[i], i, currentRow, evenStyle, oddStyle);
          currentRow++;
        }
      }

      if (footerGroup1Builder != null) {
        final rows = footerGroup1Builder!(items1);
        _renderFooterRows(rows, currentRow);
        currentRow += rows.length;
      }
    });

    if (footerBuilder != null) {
      final rows = footerBuilder!(data);
      _renderFooterRows(rows, currentRow);
    }
  }

  void _renderBodyFirstRow(List<PColumnBodyN<T>> firstRow, int rowIndex) {
    int colIndex = 0;
    for (var column in firstRow) {
      final flex = column.flex;
      final value = column.content;

      if (flex > 1) {
        _sheet.merge(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex),
          CellIndex.indexByColumnRow(
              columnIndex: colIndex + flex - 1, rowIndex: rowIndex),
        );
      }

      final cell = _sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex),
      );
      cell.value = TextCellValue(value);
      cell.cellStyle = _infoStyle(); // atau style custom lain

      colIndex += flex;
    }
  }

  void _renderFooterRows(List<List<PColumnFooter>> rows, int startRow) {
    for (int i = 0; i < rows.length; i++) {
      _renderFooterRow(rows[i], startRow + i);
    }
  }

  void _renderFooterRow(List<PColumnFooter> footers, int rowIndex) {
    int colIndex = 0;
    for (var footer in footers) {
      final span = footer.flex;
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

  void _renderTitleAndInfo(CellStyle style) {
    _sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
      ..value = TextCellValue(title)
      ..cellStyle = style;

    _sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1))
      ..value = TextCellValue('Printed by: $printedBy')
      ..cellStyle = style;
  }

  void _renderHeadersWithChildren(CellStyle style) {
    int colIndex = 0;
    for (final header in headers) {
      final hasChildren = header.children?.isNotEmpty ?? false;

      if (hasChildren) {
        final children = header.children!;
        final span = children.fold<int>(0, (sum, child) => sum + child.flex);

        _sheet.merge(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 2),
          CellIndex.indexByColumnRow(
              columnIndex: colIndex + span - 1, rowIndex: 2),
        );

        _sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 2))
          ..value = TextCellValue(header.title)
          ..cellStyle = style;

        int childCol = colIndex;
        for (final child in children) {
          if (child.flex > 1) {
            _sheet.merge(
              CellIndex.indexByColumnRow(columnIndex: childCol, rowIndex: 3),
              CellIndex.indexByColumnRow(
                  columnIndex: childCol + child.flex - 1, rowIndex: 3),
            );
          }

          _sheet.cell(
              CellIndex.indexByColumnRow(columnIndex: childCol, rowIndex: 3))
            ..value = TextCellValue(child.title)
            ..cellStyle = style;

          childCol += child.flex;
        }

        colIndex += span;
      } else {
        final span = header.flex;

        if (span > 1) {
          _sheet.merge(
            CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 2),
            CellIndex.indexByColumnRow(
                columnIndex: colIndex + span - 1, rowIndex: 3),
          );
        } else {
          _sheet.merge(
            CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 2),
            CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 3),
          );
        }

        _sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 2))
          ..value = TextCellValue(header.title)
          ..cellStyle = style;

        colIndex += span;
      }
    }
  }

  void _renderHeaders(CellStyle style) {
    int colIndex = 0;
    for (final header in headers) {
      final span = header.flex;

      if (span > 1) {
        _sheet.merge(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 2),
          CellIndex.indexByColumnRow(
              columnIndex: colIndex + span - 1, rowIndex: 2),
        );
      }

      _sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: 2))
        ..value = TextCellValue(header.title)
        ..cellStyle = style;

      colIndex += span;
    }
  }

  void _renderRow(
      T item, int index, int rowIndex, CellStyle even, CellStyle odd) {
    final style = index.isEven ? even : odd;
    int colIndex = 0;

    for (var col = 0; col < body.length; col++) {
      final column = body[col];
      final flex = column.flex;
      final value = column.contentBuilder(item, index);

      if (flex > 1) {
        _sheet.merge(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex),
          CellIndex.indexByColumnRow(
              columnIndex: colIndex + flex - 1, rowIndex: rowIndex),
        );
      }

      final cell = _sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex),
      );
      cell.value = TextCellValue(value);
      cell.cellStyle = style.copyWith(
        horizontalAlignVal:
            column.numeric ? HorizontalAlign.Right : HorizontalAlign.Left,
      );

      colIndex += flex;
    }
  }

  void _autoFitColumns() {
    final rowCount = data.length;
    int colIndex = 0;

    for (var col = 0; col < body.length; col++) {
      int maxLength = 0;
      final flex = body[col].flex;
      final headerTitle = headers.length > col ? headers[col].title : '';
      maxLength = headerTitle.length;

      for (var row = 0; row < rowCount; row++) {
        final value = body[col].contentBuilder(data[row], row);
        if (value.length > maxLength) {
          maxLength = value.length;
        }
      }

      final widthPerColumn = (maxLength.toDouble() + 2) / flex;
      for (int i = 0; i < flex; i++) {
        _sheet.setColumnWidth(colIndex + i, widthPerColumn);
      }

      colIndex += flex;
    }
  }

  CellStyle _headerCellStyle() => CellStyle(
        bold: true,
        fontColorHex: ExcelColor.white,
        backgroundColorHex: ExcelColor.lightBlue,
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
      );

  CellStyle _rowCellStyle(ExcelColor backgroundColor) => CellStyle(
        backgroundColorHex: backgroundColor,
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

  CellStyle _groupSubHeaderStyle() => CellStyle(
        bold: true,
        fontColorHex: ExcelColor.black,
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
