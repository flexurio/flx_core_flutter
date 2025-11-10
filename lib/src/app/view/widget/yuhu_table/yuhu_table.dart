import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/util/color.dart';
import 'package:flx_core_flutter/src/app/util/theme.dart';
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down.dart';
import 'package:flx_core_flutter/src/app/view/widget/table_with_body_scroll.dart';
import 'package:flx_core_flutter/src/app/view/widget/yuhu_table/table_column.dart';
import 'package:flx_core_flutter/src/app/view/widget/yuhu_table/table_data.dart';
import 'package:flx_core_flutter/src/app/view/widget/yuhu_table/table_header.dart';
import 'package:gap/gap.dart';

class YuhuTable<T> extends StatefulWidget {
  const YuhuTable({
    required this.data,
    required this.columns,
    super.key,
    this.width,
    this.rowsPerPage,
    this.rowHeight = 48,
    this.bodyHeight,
    this.status = Status.loaded,
    this.onSort,
    this.onSelectChanged,
    this.initialSortColumnIndex,
    this.initialSortAscending,
    this.freezeFirstColumn = false,
    this.freezeLastColumn = false,
  });

  final List<T> data;
  final List<TableColumn<T>> columns;
  final double? width;
  final int? rowsPerPage;
  final double rowHeight;
  final double? bodyHeight;
  final Status status;
  final void Function(int, bool)? onSort;
  final void Function(List<T>)? onSelectChanged;
  final int? initialSortColumnIndex;
  final bool? initialSortAscending;
  final bool freezeFirstColumn;
  final bool freezeLastColumn;

  @override
  State<YuhuTable<T>> createState() => _YuhuTableState<T>();
}

class _YuhuTableState<T> extends State<YuhuTable<T>> {
  late List<TableColumn<T>> _columns;
  TableColumn<T>? _frozenStart;
  TableColumn<T>? _frozenEnd;

  int? _sortIndex;
  bool _ascending = true;
  final List<T> _selected = [];

  @override
  void initState() {
    super.initState();
    _columns = List.of(widget.columns);
    if (widget.freezeFirstColumn) _frozenStart = _columns.removeAt(0);
    if (widget.freezeLastColumn) _frozenEnd = _columns.removeLast();
    _sortIndex = widget.initialSortColumnIndex;
    _ascending = widget.initialSortAscending ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderSide = BorderSide(
      color: theme.brightness == Brightness.dark
          ? MyTheme.black06dp
          : Colors.grey.shade300,
    );

    final table = _buildTable(theme, borderSide);
    final scrollController = ScrollController();

    return Column(
      children: [
        Stack(
          children: [
            Row(
              children: [
                Gap(_frozenStart?.width ?? 0),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxWidth = constraints.maxWidth;
                      final tableWidth = (widget.width ?? maxWidth)
                          .clamp(maxWidth, double.infinity);
                      return Scrollbar(
                        controller: scrollController,
                        interactive: true,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(width: tableWidth, child: table),
                        ),
                      );
                    },
                  ),
                ),
                Gap(_frozenEnd?.width ?? 0),
              ],
            ),
            if (_frozenStart != null)
              _buildFrozenColumn(_frozenStart!, borderSide, false, theme),
            if (_frozenEnd != null)
              _buildFrozenColumn(_frozenEnd!, borderSide, true, theme),
          ],
        ),
        if (widget.status == Status.progress)
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: CupertinoActivityIndicator(),
          ),
        if (widget.status == Status.error)
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Icon(Icons.error, color: Colors.red),
          ),
      ],
    );
  }

  Widget _buildTable(ThemeData theme, BorderSide borderSide) {
    final headerDecoration = BoxDecoration(
      color: theme.brightness == Brightness.dark
          ? theme.colorScheme.primary.darken(.3)
          : const Color(0xFFF0F4F8),
    );

    final columnWidths = <int, TableColumnWidth>{};
    for (var i = 0; i < _columns.length; i++) {
      final width = _columns[i].width;
      if (width != null) columnWidths[i] = FixedColumnWidth(width);
    }

    final headers = List.generate(_columns.length, (i) {
      final column = _columns[i];
      final index = widget.freezeFirstColumn ? i + 1 : i;
      return _buildTableHeader(index, column);
    });

    if (widget.onSelectChanged != null) {
      columnWidths[_columns.length] = const FixedColumnWidth(80);
      headers.add(
        TableHeader(
          column: TableColumn(title: '', builder: (_, __) => Container()),
          isSort: false,
          ascending: _ascending,
        ),
      );
    }

    final rows = _buildRows(borderSide);

    return TableWithBodyScroll(
      heightBody: widget.bodyHeight,
      columnWidths: columnWidths,
      border: TableBorder(
        verticalInside:
            borderSide.copyWith(color: borderSide.color.withOpacity(0.4)),
      ),
      children: [
        TableRow(decoration: headerDecoration, children: headers),
        ...rows,
      ],
    );
  }

  List<TableRow> _buildRows(BorderSide borderSide) {
    final rows = List<TableRow>.generate(widget.data.length, (rowIndex) {
      final row = <Widget>[
        for (var colIndex = 0; colIndex < _columns.length; colIndex++)
          TableData(
            height: widget.rowHeight,
            alignment: _columns[colIndex].alignment,
            borderSide: borderSide,
            child: _columns[colIndex].builder(widget.data[rowIndex], rowIndex),
          ),
      ];

      if (widget.onSelectChanged != null) {
        row.add(_buildSelectCheckboxCell(rowIndex, borderSide));
      }

      return TableRow(children: row);
    });

    if (widget.rowsPerPage != null && rows.length < widget.rowsPerPage!) {
      rows.addAll(_buildEmptyRows(borderSide));
    }

    return rows;
  }

  Widget _buildSelectCheckboxCell(int rowIndex, BorderSide borderSide) {
    final item = widget.data[rowIndex];
    final isSelected = _selected.contains(item);

    return TableData(
      height: widget.rowHeight,
      alignment: Alignment.center,
      borderSide: borderSide,
      child: Checkbox(
        value: isSelected,
        onChanged: (value) {
          if (value ?? false) {
            _selected.add(item);
          } else {
            _selected.remove(item);
          }
          setState(() {});
          widget.onSelectChanged?.call(_selected);
        },
      ),
    );
  }

  List<TableRow> _buildEmptyRows(BorderSide borderSide) {
    return List.generate(
      widget.rowsPerPage! - widget.data.length,
      (_) => TableRow(
        children: List.generate(
          _columns.length + (widget.onSelectChanged != null ? 1 : 0),
          (i) => TableData(
            height: widget.rowHeight,
            alignment:
                i < _columns.length ? _columns[i].alignment : Alignment.center,
            borderSide: borderSide,
            child: Container(),
          ),
        ),
      ),
    );
  }

  Widget _buildFrozenColumn(
    TableColumn<T> column,
    BorderSide borderSide,
    bool isLast,
    ThemeData theme,
  ) {
    final headerDecoration = BoxDecoration(
      color: theme.brightness == Brightness.dark
          ? theme.colorScheme.primary.darken(.3)
          : const Color(0xFFF0F4F8),
    );

    final header = TableRow(
      decoration: headerDecoration,
      children: [
        _buildTableHeader(0, column),
      ],
    );

    final rows = List<TableRow>.generate(
      widget.data.length,
      (i) => TableRow(
        decoration: BoxDecoration(color: theme.cardColor),
        children: [
          TableData(
            height: widget.rowHeight,
            alignment: column.alignment,
            borderSide: borderSide,
            child: column.builder(widget.data[i], i),
          ),
        ],
      ),
    );

    if (widget.rowsPerPage != null && rows.length < widget.rowsPerPage!) {
      rows.addAll(
        List.generate(
          widget.rowsPerPage! - rows.length,
          (_) => TableRow(
            decoration: BoxDecoration(color: theme.cardColor),
            children: [
              TableData(
                height: widget.rowHeight,
                alignment: column.alignment,
                borderSide: borderSide,
                child: Container(),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: isLast ? Alignment.centerRight : Alignment.centerLeft,
      child: ClipRRect(
        child: Container(
          margin:
              EdgeInsets.only(left: isLast ? 30 : 0, right: isLast ? 0 : 30),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: theme.modeCondition(Colors.black12, Colors.black54),
                blurRadius: 5,
                offset: Offset(isLast ? -3 : 3, -2),
              ),
            ],
          ),
          child: TableWithBodyScroll(
            heightBody: widget.bodyHeight,
            columnWidths: {0: FixedColumnWidth(column.width ?? 0)},
            children: [
              header,
              ...rows,
            ],
          ),
        ),
      ),
    );
  }

  TableHeader<T> _buildTableHeader(int index, TableColumn<T> column) {
    return TableHeader(
      column: column,
      ascending: _ascending,
      isSort: _sortIndex == index,
      onTap: () {
        if (column.sortNum == null && column.sortString == null) {
          widget.onSort?.call(index, !_ascending);
        } else {
          setState(() {
            if (_sortIndex != index) {
              _sortIndex = index;
              _ascending = true;
            } else {
              _ascending = !_ascending;
            }
          });
        }
      },
    );
  }
}
