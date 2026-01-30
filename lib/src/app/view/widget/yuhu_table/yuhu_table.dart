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
import 'package:screen_identifier/screen_identifier.dart';

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
  int? _sortIndex;
  bool _ascending = true;
  final List<T> _selected = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _sortIndex = widget.initialSortColumnIndex;
    _ascending = widget.initialSortAscending ?? true;
  }

  @override
  void didUpdateWidget(covariant YuhuTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSortColumnIndex != oldWidget.initialSortColumnIndex) {
      _sortIndex = widget.initialSortColumnIndex;
    }
    if (widget.initialSortAscending != oldWidget.initialSortAscending) {
      _ascending = widget.initialSortAscending ?? true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderSide = BorderSide(
      color: theme.brightness == Brightness.dark
          ? MyTheme.black06dp
          : Colors.grey.shade300,
    );

    return ScreenIdentifierBuilder(
      builder: (context, screenIdentifier) {
        // Use a more inclusive check for mobile layout
        final isSmall =
            screenIdentifier.conditions(md: false, sm: true) == true ||
                MediaQuery.of(context).size.width < 600;
        final freezeFirst = !isSmall && widget.freezeFirstColumn;
        final freezeLast = !isSmall && widget.freezeLastColumn;

        final scrollableColumns = List.of(widget.columns);
        TableColumn<T>? frozenStart;
        TableColumn<T>? frozenEnd;

        if (freezeFirst && scrollableColumns.isNotEmpty) {
          frozenStart = scrollableColumns.removeAt(0);
        }
        if (freezeLast && scrollableColumns.isNotEmpty) {
          frozenEnd = scrollableColumns.removeLast();
        }

        final table = _buildTable(
          theme,
          borderSide,
          scrollableColumns,
          freezeFirst,
          freezeLast,
        );

        return Column(
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    Gap(frozenStart?.width ?? 0),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth;
                          final tableWidth = (widget.width ?? maxWidth)
                              .clamp(maxWidth, double.infinity);
                          return Scrollbar(
                            controller: _scrollController,
                            interactive: true,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(width: tableWidth, child: table),
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(frozenEnd?.width ?? 0),
                  ],
                ),
                if (frozenStart != null)
                  _buildFrozenColumn(0, frozenStart, borderSide, false, theme),
                if (frozenEnd != null)
                  _buildFrozenColumn(
                    widget.columns.length - 1,
                    frozenEnd,
                    borderSide,
                    true,
                    theme,
                  ),
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
      },
    );
  }

  Widget _buildTable(
    ThemeData theme,
    BorderSide borderSide,
    List<TableColumn<T>> scrollableColumns,
    bool freezeFirst,
    bool freezeLast,
  ) {
    final headerDecoration = BoxDecoration(
      color: theme.brightness == Brightness.dark
          ? theme.colorScheme.primary.darken(.3)
          : const Color(0xFFF0F4F8),
    );

    final columnWidths = <int, TableColumnWidth>{};
    for (var i = 0; i < scrollableColumns.length; i++) {
      final width = scrollableColumns[i].width;
      if (width != null) columnWidths[i] = FixedColumnWidth(width);
    }

    final headers = List.generate(scrollableColumns.length, (i) {
      final column = scrollableColumns[i];
      final index = freezeFirst ? i + 1 : i;
      return _buildTableHeader(index, column);
    });

    if (widget.onSelectChanged != null) {
      columnWidths[scrollableColumns.length] = const FixedColumnWidth(80);
      headers.add(
        TableHeader(
          column: TableColumn(title: '', builder: (_, __) => Container()),
          isSort: false,
          ascending: _ascending,
        ),
      );
    }

    final rows = _buildRows(borderSide, scrollableColumns);

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

  List<TableRow> _buildRows(
    BorderSide borderSide,
    List<TableColumn<T>> scrollableColumns,
  ) {
    final rows = List<TableRow>.generate(widget.data.length, (rowIndex) {
      final row = <Widget>[
        for (var colIndex = 0; colIndex < scrollableColumns.length; colIndex++)
          TableData(
            height: widget.rowHeight,
            alignment: scrollableColumns[colIndex].alignment,
            borderSide: borderSide,
            child: scrollableColumns[colIndex].builder(
              widget.data[rowIndex],
              rowIndex,
            ),
          ),
      ];

      if (widget.onSelectChanged != null) {
        row.add(_buildSelectCheckboxCell(rowIndex, borderSide));
      }

      return TableRow(children: row);
    });

    if (widget.rowsPerPage != null && rows.length < widget.rowsPerPage!) {
      rows.addAll(_buildEmptyRows(borderSide, scrollableColumns));
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

  List<TableRow> _buildEmptyRows(
    BorderSide borderSide,
    List<TableColumn<T>> scrollableColumns,
  ) {
    return List.generate(
      widget.rowsPerPage! - widget.data.length,
      (_) => TableRow(
        children: List.generate(
          scrollableColumns.length + (widget.onSelectChanged != null ? 1 : 0),
          (i) => TableData(
            height: widget.rowHeight,
            alignment: i < scrollableColumns.length
                ? scrollableColumns[i].alignment
                : Alignment.center,
            borderSide: borderSide,
            child: Container(),
          ),
        ),
      ),
    );
  }

  Widget _buildFrozenColumn(
    int index,
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
        _buildTableHeader(index, column),
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
