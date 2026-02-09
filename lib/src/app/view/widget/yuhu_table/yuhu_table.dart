import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/util/color.dart';
import 'package:flx_core_flutter/src/app/util/theme.dart';
import 'package:flx_core_flutter/src/app/view/page/menu/menu_page.dart';
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
  int? _hoveredRowIndex;

  bool get enableHoverEffect => MenuPage.enableHoverEffect;

  ThemeData get _theme => Theme.of(context);
  BorderSide get _borderSide => BorderSide(
        color: _theme.brightness == Brightness.dark
            ? MyTheme.black06dp
            : Colors.grey.shade300,
      );
  BoxDecoration get _headerDecoration => BoxDecoration(
        color: _theme.brightness == Brightness.dark
            ? _theme.colorScheme.primary.darken(.3)
            : const Color(0xFFF0F4F8),
      );
  Color get _hoverColor {
    final primary = _theme.colorScheme.primary;
    return _theme.modeCondition(
      Color.alphaBlend(
          primary.lighten(.5).withValues(alpha: .15), _theme.cardColor),
      Color.alphaBlend(primary.withValues(alpha: .2), _theme.cardColor),
    );
  }

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
                  _buildFrozenColumn(0, frozenStart, false),
                if (frozenEnd != null)
                  _buildFrozenColumn(
                    widget.columns.length - 1,
                    frozenEnd,
                    true,
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

    final rows = _buildRows(scrollableColumns);

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

  List<TableRow> _buildRows(List<TableColumn<T>> scrollableColumns) {
    return _generateTableRows(
      cellBuilder: (rowIndex, item) {
        final row = <Widget>[
          for (var colIndex = 0;
              colIndex < scrollableColumns.length;
              colIndex++)
            TableData(
              height: widget.rowHeight,
              alignment: scrollableColumns[colIndex].alignment,
              borderSide: _borderSide,
              child: scrollableColumns[colIndex].builder(item, rowIndex),
            ),
        ];

        if (widget.onSelectChanged != null) {
          row.add(_buildSelectCheckboxCell(rowIndex));
        }
        return row;
      },
      emptyCellBuilder: (rowIndex) {
        return List.generate(
          scrollableColumns.length + (widget.onSelectChanged != null ? 1 : 0),
          (i) => TableData(
            height: widget.rowHeight,
            alignment: i < scrollableColumns.length
                ? scrollableColumns[i].alignment
                : Alignment.center,
            borderSide: _borderSide,
            child: Container(),
          ),
        );
      },
    );
  }

  Widget _wrapWithHover({required int rowIndex, required Widget child}) {
    if (!enableHoverEffect) return child;

    return MouseRegion(
      hitTestBehavior: HitTestBehavior.opaque,
      onEnter: (_) {
        if (_hoveredRowIndex != rowIndex) {
          setState(() => _hoveredRowIndex = rowIndex);
        }
      },
      onExit: (_) {
        if (_hoveredRowIndex == rowIndex) {
          setState(() => _hoveredRowIndex = null);
        }
      },
      child: ColoredBox(
        color: Colors.transparent,
        child: child,
      ),
    );
  }

  Widget _buildSelectCheckboxCell(int rowIndex) {
    final item = widget.data[rowIndex];
    final isSelected = _selected.contains(item);

    return TableData(
      height: widget.rowHeight,
      alignment: Alignment.center,
      borderSide: _borderSide,
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

  List<TableRow> _generateTableRows({
    required List<Widget> Function(int rowIndex, T item) cellBuilder,
    required List<Widget> Function(int rowIndex) emptyCellBuilder,
    Color? baseColor,
  }) {
    final rows = List<TableRow>.generate(widget.data.length, (rowIndex) {
      final isHovered = enableHoverEffect && _hoveredRowIndex == rowIndex;
      return TableRow(
        decoration: BoxDecoration(
          color: isHovered ? _hoverColor : baseColor,
        ),
        children: cellBuilder(rowIndex, widget.data[rowIndex])
            .map((child) => _wrapWithHover(rowIndex: rowIndex, child: child))
            .toList(),
      );
    });

    if (widget.rowsPerPage != null && rows.length < widget.rowsPerPage!) {
      final emptyRowsCount = widget.rowsPerPage! - rows.length;
      rows.addAll(
        List.generate(
          emptyRowsCount,
          (emptyIndex) {
            final rowIndex = widget.data.length + emptyIndex;
            final isHovered = enableHoverEffect && _hoveredRowIndex == rowIndex;
            return TableRow(
              decoration: BoxDecoration(
                color: isHovered ? _hoverColor : baseColor,
              ),
              children: emptyCellBuilder(rowIndex)
                  .map(
                    (child) => enableHoverEffect
                        ? _wrapWithHover(rowIndex: rowIndex, child: child)
                        : child,
                  )
                  .toList(),
            );
          },
        ),
      );
    }
    return rows;
  }

  Widget _buildFrozenColumn(
    int index,
    TableColumn<T> column,
    bool isLast,
  ) {
    final header = TableRow(
      decoration: _headerDecoration,
      children: [
        _buildTableHeader(index, column),
      ],
    );

    final rows = _generateTableRows(
      baseColor: _theme.cardColor,
      cellBuilder: (rowIndex, item) => [
        TableData(
          height: widget.rowHeight,
          alignment: column.alignment,
          borderSide: _borderSide,
          child: column.builder(item, rowIndex),
        ),
      ],
      emptyCellBuilder: (rowIndex) => [
        TableData(
          height: widget.rowHeight,
          alignment: column.alignment,
          borderSide: _borderSide,
          child: Container(),
        ),
      ],
    );

    return Align(
      alignment: isLast ? Alignment.centerRight : Alignment.centerLeft,
      child: ClipRRect(
        child: Container(
          margin:
              EdgeInsets.only(left: isLast ? 30 : 0, right: isLast ? 0 : 30),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: _theme.modeCondition(Colors.black12, Colors.black54),
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
