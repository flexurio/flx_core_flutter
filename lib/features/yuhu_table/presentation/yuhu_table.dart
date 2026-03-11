import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/features/menu/presentation/menu_page.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/table_column.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/table_data.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/table_header.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/yuhu_table_header_draggable.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/yuhu_table_section.dart';
import 'package:flx_core_flutter/src/app/util/color.dart';
import 'package:flx_core_flutter/src/app/util/theme.dart';
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down.dart';
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
  final Set<int> _pinnedLeft = {};
  final Set<int> _pinnedRight = {};
  final Map<int, double> _columnWidths = {};
  List<int> _columnOrder = [];

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
    _columnOrder = List.generate(widget.columns.length, (index) => index);
    if (widget.freezeFirstColumn) _pinnedLeft.add(0);
    if (widget.freezeLastColumn && widget.columns.isNotEmpty) {
      _pinnedRight.add(widget.columns.length - 1);
    }

    for (var i = 0; i < widget.columns.length; i++) {
      if (widget.columns[i].width != null) {
        _columnWidths[i] = widget.columns[i].width!;
      }
    }

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
      if (widget.freezeFirstColumn) {
        _pinnedLeft.add(0);
      } else {
        _pinnedLeft.remove(0);
      }
    }
    if (widget.freezeLastColumn != oldWidget.freezeLastColumn) {
      if (widget.freezeLastColumn && widget.columns.isNotEmpty) {
        _pinnedRight.add(widget.columns.length - 1);
      } else {
        _pinnedRight.remove(widget.columns.length - 1);
      }
    }

    if (widget.columns.length != oldWidget.columns.length) {
      final newIndices = List.generate(
        widget.columns.length,
        (index) => index,
      );
      // Keep existing order for common indices, add new ones at the end,
      // remove gone ones
      final keptOrder =
          _columnOrder.where((i) => i < widget.columns.length).toList();
      final addedIndices =
          newIndices.where((i) => !_columnOrder.contains(i)).toList();
      _columnOrder = [...keptOrder, ...addedIndices];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenIdentifierBuilder(
      builder: (context, screenIdentifier) {
        final isSmall =
            screenIdentifier.conditions(md: false, sm: true) == true ||
                MediaQuery.of(context).size.width < 1000;

        final leftPinnedEntries = <(int, TableColumn<T>)>[];
        final centerPinnedEntries = <(int, TableColumn<T>)>[];
        final rightPinnedEntries = <(int, TableColumn<T>)>[];

        for (final i in _columnOrder) {
          final entry = (i, widget.columns[i]);
          if (!isSmall && _pinnedLeft.contains(i)) {
            leftPinnedEntries.add(entry);
          } else if (!isSmall && _pinnedRight.contains(i)) {
            rightPinnedEntries.add(entry);
          } else {
            centerPinnedEntries.add(entry);
          }
        }

        final table = _buildSection(
          entries: centerPinnedEntries,
          vController: _vMiddleController,
          showScrollbar: rightPinnedEntries.isEmpty,
        );

        final startWidth = leftPinnedEntries.fold<double>(
          0,
          (p, c) => p + (_columnWidths[c.$1] ?? c.$2.width ?? 0),
        );
        final endWidth = rightPinnedEntries.fold<double>(
          0,
          (p, c) => p + (_columnWidths[c.$1] ?? c.$2.width ?? 0),
        );

        return Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;

                final totalCenterWidth = centerPinnedEntries.fold<double>(
                      0,
                      (prev, col) =>
                          prev + (_columnWidths[col.$1] ?? col.$2.width ?? 0),
                    ) +
                    (widget.onSelectChanged != null ? 80 : 0);

                final maxScrollWidth = (maxWidth - startWidth - endWidth)
                    .clamp(0.0, double.infinity);
                final actualScrollWidth =
                    totalCenterWidth.clamp(0.0, maxScrollWidth);
                final totalTableWidth =
                    startWidth + actualScrollWidth + endWidth;

                return Center(
                  child: SizedBox(
                    width: totalTableWidth,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: startWidth,
                            right: endWidth,
                          ),
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
                                  width: totalCenterWidth,
                                  child: table,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (leftPinnedEntries.isNotEmpty)
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: startWidth,
                            child: _buildSection(
                              entries: leftPinnedEntries,
                              isPinned: true,
                              vController: _vStartController,
                              showScrollbar: false,
                            ),
                          ),
                        if (rightPinnedEntries.isNotEmpty)
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            width: endWidth,
                            child: _buildSection(
                              entries: rightPinnedEntries,
                              isPinned: true,
                              isRightSection: true,
                              vController: _vEndController,
                              showScrollbar: true,
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

  Widget _buildSection({
    required List<(int, TableColumn<T>)> entries,
    required ScrollController? vController,
    bool isPinned = false,
    bool isRightSection = false,
    bool showScrollbar = true,
  }) {
    final columnWidths = <int, TableColumnWidth>{};
    for (var i = 0; i < entries.length; i++) {
      final index = entries[i].$1;
      final width = _columnWidths[index] ?? entries[i].$2.width;
      if (width != null) columnWidths[i] = FixedColumnWidth(width);
    }

    final headers = List.generate(entries.length, (i) {
      final index = entries[i].$1;
      final column = entries[i].$2;
      return _buildTableHeader(
        index,
        column,
        pinnedPosition: _pinnedLeft.contains(index)
            ? TablePinPosition.left
            : (_pinnedRight.contains(index)
                ? TablePinPosition.right
                : TablePinPosition.none),
        onPinnedPositionChanged: (p) => setState(() {
          _pinnedLeft.remove(index);
          _pinnedRight.remove(index);
          if (p == TablePinPosition.left) {
            _pinnedLeft.add(index);
          } else if (p == TablePinPosition.right) {
            _pinnedRight.add(index);
          }
        }),
      );
    });

    if (!isPinned && widget.onSelectChanged != null) {
      columnWidths[entries.length] = const FixedColumnWidth(80);
      headers.add(
        TableHeader(
          column: TableColumn(title: '', builder: (_, __) => Container()),
          isSort: false,
          ascending: _ascending,
        ),
      );
    }

    final rows = _buildRows(entries, isPinned: isPinned);

    return YuhuTableSection(
      columnWidths: columnWidths,
      headers: headers,
      rows: rows,
      borderSide: _borderSide,
      headerDecoration: _headerDecoration,
      bodyHeight: widget.bodyHeight,
      vController: vController,
      showScrollbar: showScrollbar,
      alignment: isRightSection ? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        color: _theme.cardColor,
        border: isPinned
            ? Border(
                left: isRightSection ? _borderSide : BorderSide.none,
                right: isRightSection ? BorderSide.none : _borderSide,
              )
            : null,
      ),
    );
  }

  List<TableRow> _buildRows(
    List<(int, TableColumn<T>)> entries, {
    bool isPinned = false,
  }) {
    return _generateTableRows(
      cellBuilder: (rowIndex, item) {
        final row = <Widget>[
          for (var i = 0; i < entries.length; i++)
            TableData(
              height: widget.rowHeight,
              alignment: entries[i].$2.alignment,
              borderSide: _borderSide,
              child: entries[i].$2.builder(item, rowIndex),
            ),
        ];

        if (!isPinned && widget.onSelectChanged != null) {
          row.add(_buildSelectCheckboxCell(rowIndex));
        }
        return row;
      },
      emptyCellBuilder: (rowIndex) {
        final cells = <Widget>[
          for (var i = 0; i < entries.length; i++)
            TableData(
              height: widget.rowHeight,
              alignment: entries[i].$2.alignment,
              borderSide: _borderSide,
              child: Container(),
            ),
        ];

        if (!isPinned && widget.onSelectChanged != null) {
          cells.add(
            TableData(
              height: widget.rowHeight,
              alignment: Alignment.center,
              borderSide: _borderSide,
              child: Container(),
            ),
          );
        }
        return cells;
      },
    );
  }

  Widget _buildTableHeader(
    int index,
    TableColumn<T> column, {
    TablePinPosition pinnedPosition = TablePinPosition.none,
    void Function(TablePinPosition)? onPinnedPositionChanged,
  }) {
    return YuhuTableDraggableHeader<T>(
      index: index,
      column: column,
      isSort: _sortIndex == index,
      ascending: _ascending,
      pinnedPosition: pinnedPosition,
      currentWidth: _columnWidths[index] ?? column.width ?? 100.0,
      headerDecoration: _headerDecoration,
      onPinnedPositionChanged: onPinnedPositionChanged,
      onResizing: (delta) {
        setState(() {
          final currentWidth = _columnWidths[index] ?? column.width ?? 100.0;
          _columnWidths[index] = (currentWidth + delta).clamp(50.0, 1000.0);
        });
      },
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
      onDrop: (fromIndex) {
        setState(() {
          // Adopt the pinning status of the target section
          if (pinnedPosition != TablePinPosition.none) {
            if (_pinnedLeft.contains(index)) {
              _pinnedLeft.add(fromIndex);
              _pinnedRight.remove(fromIndex);
            } else if (_pinnedRight.contains(index)) {
              _pinnedRight.add(fromIndex);
              _pinnedLeft.remove(fromIndex);
            }
          } else {
            _pinnedLeft.remove(fromIndex);
            _pinnedRight.remove(fromIndex);
          }

          final oldPos = _columnOrder.indexOf(fromIndex);
          final newPos = _columnOrder.indexOf(index);
          if (oldPos != -1 && newPos != -1) {
            _columnOrder
              ..removeAt(oldPos)
              ..insert(newPos, fromIndex);
          }
        });
      },
    );
  }
}
