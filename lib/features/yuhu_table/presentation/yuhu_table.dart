import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/util/color.dart';
import 'package:flx_core_flutter/src/app/util/theme.dart';
import 'package:flx_core_flutter/features/menu/presentation/menu_page.dart';
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down.dart';
import 'package:flx_core_flutter/src/app/view/widget/table_with_body_scroll.dart';
import 'table_column.dart';
import 'table_data.dart';
import 'table_header.dart';
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
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _vMiddleController = ScrollController();
  final ScrollController _vStartController = ScrollController();
  final ScrollController _vEndController = ScrollController();
  int? _hoveredRowIndex;
  bool _isSyncing = false;
  late bool _freezeFirst;
  late bool _freezeLast;

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
        primary.lighten(.5).withValues(alpha: .15),
        _theme.cardColor,
      ),
      Color.alphaBlend(primary.withValues(alpha: .2), _theme.cardColor),
    );
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _vMiddleController.dispose();
    _vStartController.dispose();
    _vEndController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _sortIndex = widget.initialSortColumnIndex;
    _ascending = widget.initialSortAscending ?? true;
    _freezeFirst = widget.freezeFirstColumn;
    _freezeLast = widget.freezeLastColumn;

    _vMiddleController.addListener(() => _syncScroll(_vMiddleController));
    _vStartController.addListener(() => _syncScroll(_vStartController));
    _vEndController.addListener(() => _syncScroll(_vEndController));
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
    if (widget.freezeFirstColumn != oldWidget.freezeFirstColumn) {
      _freezeFirst = widget.freezeFirstColumn;
    }
    if (widget.freezeLastColumn != oldWidget.freezeLastColumn) {
      _freezeLast = widget.freezeLastColumn;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenIdentifierBuilder(
      builder: (context, screenIdentifier) {
        final isSmall =
            screenIdentifier.conditions(md: false, sm: true) == true ||
                MediaQuery.of(context).size.width < 1000;
        final freezeFirst = !isSmall && _freezeFirst;
        final freezeLast = !isSmall && _freezeLast;

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
          _theme,
          _borderSide,
          scrollableColumns,
          freezeFirst,
          freezeLast,
          _vMiddleController,
          showScrollbar: !freezeLast, // Only show middle if no end column
        );

        final startWidth = frozenStart?.width ?? 0;
        final endWidth = frozenEnd?.width ?? 0;

        return Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;

                // Calculate total width of scrollable columns
                final totalScrollableWidth = scrollableColumns.fold<double>(
                      0.0,
                      (prev, col) => prev + (col.width ?? 0),
                    ) +
                    (widget.onSelectChanged != null ? 80 : 0);

                final maxScrollWidth = (maxWidth - startWidth - endWidth)
                    .clamp(0.0, double.infinity);
                final actualScrollWidth =
                    totalScrollableWidth.clamp(0.0, maxScrollWidth);
                final totalTableWidth =
                    startWidth + actualScrollWidth + endWidth;

                return Center(
                  child: SizedBox(
                    width: totalTableWidth,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Main Scrollable Content
                        Padding(
                          padding: EdgeInsets.only(
                              left: startWidth, right: endWidth),
                          child: SizedBox(
                            width: actualScrollWidth,
                            child: Scrollbar(
                              controller: _horizontalScrollController,
                              interactive: true,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: _horizontalScrollController,
                                scrollDirection: Axis.horizontal,
                                physics: const ClampingScrollPhysics(),
                                child: SizedBox(
                                  width: totalScrollableWidth,
                                  child: table,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Frozen Start Column
                        if (frozenStart != null)
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: startWidth,
                            child: _buildFrozenColumn(
                              0,
                              frozenStart,
                              false,
                              _vStartController,
                              showScrollbar: false,
                            ),
                          ),

                        // Frozen End Column
                        if (frozenEnd != null)
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            width: endWidth,
                            child: _buildFrozenColumn(
                              widget.columns.length - 1,
                              frozenEnd,
                              true,
                              _vEndController,
                              showScrollbar:
                                  true, // Show vertical scrollbar here
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
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

  List<TableRow> _generateTableRows({
    required List<Widget> Function(int rowIndex, T item) cellBuilder,
    required List<Widget> Function(int rowIndex) emptyCellBuilder,
    Color? baseColor,
  }) {
    final effectiveBaseColor = baseColor ?? _theme.cardColor;
    final rows = List<TableRow>.generate(widget.data.length, (rowIndex) {
      final isHovered = enableHoverEffect && _hoveredRowIndex == rowIndex;
      return TableRow(
        decoration: BoxDecoration(
          color: isHovered ? _hoverColor : effectiveBaseColor,
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
                color: isHovered ? _hoverColor : effectiveBaseColor,
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

  void _syncScroll(ScrollController source) {
    if (_isSyncing) return;
    _isSyncing = true;
    final offset = source.offset;
    if (_vMiddleController.hasClients &&
        _vMiddleController != source &&
        _vMiddleController.offset != offset) {
      _vMiddleController.jumpTo(offset);
    }
    if (_vStartController.hasClients &&
        _vStartController != source &&
        _vStartController.offset != offset) {
      _vStartController.jumpTo(offset);
    }
    if (_vEndController.hasClients &&
        _vEndController != source &&
        _vEndController.offset != offset) {
      _vEndController.jumpTo(offset);
    }
    _isSyncing = false;
  }

  Widget _buildTable(
    ThemeData theme,
    BorderSide borderSide,
    List<TableColumn<T>> scrollableColumns,
    bool freezeFirst,
    bool freezeLast,
    ScrollController? vController, {
    bool showScrollbar = true,
  }) {
    final columnWidths = <int, TableColumnWidth>{};
    for (var i = 0; i < scrollableColumns.length; i++) {
      final width = scrollableColumns[i].width;
      if (width != null) columnWidths[i] = FixedColumnWidth(width);
    }

    final headers = List.generate(scrollableColumns.length, (i) {
      final column = scrollableColumns[i];
      final index = freezeFirst ? i + 1 : i;
      final isPinnableStart = i == 0 && !freezeFirst;
      final isPinnableEnd = !freezeLast && i == scrollableColumns.length - 1;

      return _buildTableHeader(
        index,
        column,
        isPinned: false,
        onPinChanged: (isPinnableStart || isPinnableEnd)
            ? (p) => setState(() {
                  if (isPinnableStart) {
                    _freezeFirst = p;
                  } else {
                    _freezeLast = p;
                  }
                })
            : null,
      );
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
      controller: vController,
      physics: const ClampingScrollPhysics(),
      showScrollbar: showScrollbar,
      border: TableBorder(
        verticalInside:
            borderSide.copyWith(color: borderSide.color.withOpacity(0.4)),
      ),
      children: [
        TableRow(decoration: _headerDecoration, children: headers),
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
        final cells = <Widget>[
          for (var i = 0; i < scrollableColumns.length; i++)
            TableData(
              height: widget.rowHeight,
              alignment: scrollableColumns[i].alignment,
              borderSide: _borderSide,
              child: Container(),
            ),
        ];

        if (widget.onSelectChanged != null) {
          cells.add(TableData(
            height: widget.rowHeight,
            alignment: Alignment.center,
            borderSide: _borderSide,
            child: Container(),
          ));
        }
        return cells;
      },
    );
  }

  Widget _buildFrozenColumn(
    int index,
    TableColumn<T> column,
    bool isLast,
    ScrollController? vController, {
    bool showScrollbar = true,
  }) {
    final header = TableRow(
      decoration: _headerDecoration,
      children: [
        _buildTableHeader(
          index,
          column,
          isPinned: true,
          onPinChanged: (p) => setState(() {
            if (index == 0) {
              _freezeFirst = p;
            } else {
              _freezeLast = p;
            }
          }),
        ),
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
      child: Container(
        decoration: BoxDecoration(
          color: _theme.cardColor,
          border: Border(
            left: isLast ? _borderSide : BorderSide.none,
            right: isLast ? BorderSide.none : _borderSide,
          ),
        ),
        child: TableWithBodyScroll(
          heightBody: widget.bodyHeight,
          columnWidths: {0: FixedColumnWidth(column.width ?? 0)},
          controller: vController,
          physics: const ClampingScrollPhysics(),
          showScrollbar: showScrollbar,
          border: TableBorder(
            verticalInside:
                _borderSide.copyWith(color: _borderSide.color.withOpacity(0.4)),
          ),
          children: [
            header,
            ...rows,
          ],
        ),
      ),
    );
  }

  TableHeader<T> _buildTableHeader(
    int index,
    TableColumn<T> column, {
    bool isPinned = false,
    void Function(bool)? onPinChanged,
  }) {
    return TableHeader(
      column: column,
      ascending: _ascending,
      isSort: _sortIndex == index,
      isPinned: isPinned,
      onPinChanged: onPinChanged,
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
