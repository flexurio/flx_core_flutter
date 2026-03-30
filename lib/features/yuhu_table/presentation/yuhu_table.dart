import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/src/yuhu_table_controller.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/src/yuhu_table_layout.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/src/yuhu_table_rows_generator.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/src/yuhu_table_style.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/table_column.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/table_data.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/table_header.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/yuhu_table_header_draggable.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/yuhu_table_section.dart';
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down/f_drop_down_status.dart';
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
    this.expand = true,
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
  final bool expand;

  @override
  State<YuhuTable<T>> createState() => _YuhuTableState<T>();
}

class _YuhuTableState<T> extends State<YuhuTable<T>> {
  late final YuhuTableController<T> _controller;
  late YuhuTableStyle _style;

  @override
  void initState() {
    super.initState();
    _controller = YuhuTableController<T>();
    _controller.init(
      widget.columns,
      initialSortColumnIndex: widget.initialSortColumnIndex,
      initialSortAscending: widget.initialSortAscending,
      freezeFirstColumn: widget.freezeFirstColumn,
      freezeLastColumn: widget.freezeLastColumn,
      onSyncScroll: () => _controller.syncScroll(_controller.vMiddleController),
    );
  }

  @override
  void didUpdateWidget(covariant YuhuTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.update(
      columns: widget.columns,
      oldColumns: oldWidget.columns,
      initialSortColumnIndex: widget.initialSortColumnIndex,
      oldInitialSortColumnIndex: oldWidget.initialSortColumnIndex,
      initialSortAscending: widget.initialSortAscending,
      oldInitialSortAscending: oldWidget.initialSortAscending,
      freezeFirstColumn: widget.freezeFirstColumn,
      oldFreezeFirstColumn: oldWidget.freezeFirstColumn,
      freezeLastColumn: widget.freezeLastColumn,
      oldFreezeLastColumn: oldWidget.freezeLastColumn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _style = YuhuTableStyle(context);

    return ScreenIdentifierBuilder(
      builder: (context, screenIdentifier) {
        final isSmall =
            screenIdentifier.conditions(md: false, sm: true) == true ||
                MediaQuery.of(context).size.width < 1000;

        final leftPinnedEntries = <(int, TableColumn<T>)>[];
        final centerPinnedEntries = <(int, TableColumn<T>)>[];
        final rightPinnedEntries = <(int, TableColumn<T>)>[];

        for (final i in _controller.columnOrder) {
          final entry = (i, widget.columns[i]);
          if (!isSmall && _controller.pinnedLeft.contains(i)) {
            leftPinnedEntries.add(entry);
          } else if (!isSmall && _controller.pinnedRight.contains(i)) {
            rightPinnedEntries.add(entry);
          } else {
            centerPinnedEntries.add(entry);
          }
        }

        final startWidth = leftPinnedEntries.fold<double>(
          0,
          (p, c) =>
              p + (_controller.columnWidths[c.$1] ?? c.$2.width ?? 100.0),
        );
        final endWidth = rightPinnedEntries.fold<double>(
          0,
          (p, c) =>
              p + (_controller.columnWidths[c.$1] ?? c.$2.width ?? 100.0),
        );

        final totalCenterWidth = centerPinnedEntries.fold<double>(
              0,
              (prev, col) =>
                  prev +
                  (_controller.columnWidths[col.$1] ?? col.$2.width ?? 100.0),
            ) +
            (widget.onSelectChanged != null ? 80 : 0);

        return Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final maxScrollWidth = (maxWidth - startWidth - endWidth)
                    .clamp(0.0, double.infinity);
                final actualScrollWidth =
                    totalCenterWidth.clamp(0.0, maxScrollWidth);
                final totalTableWidth =
                    startWidth + actualScrollWidth + endWidth;

                final expandWidth = widget.expand
                    ? (totalCenterWidth < maxScrollWidth
                        ? maxScrollWidth
                        : totalCenterWidth)
                    : totalCenterWidth;

                return YuhuTableLayout(
                  startWidth: startWidth,
                  endWidth: endWidth,
                  actualScrollWidth:
                      widget.expand ? maxScrollWidth : actualScrollWidth,
                  totalCenterWidth: expandWidth,
                  totalTableWidth: widget.expand
                      ? (startWidth + maxScrollWidth + endWidth)
                      : totalTableWidth,
                  decoration: _style.containerDecoration,
                  horizontalScrollController:
                      _controller.horizontalScrollController,
                  centerTable: _buildSection(
                    entries: centerPinnedEntries,
                    vController: _controller.vMiddleController,
                    showScrollbar: rightPinnedEntries.isEmpty,
                    availableWidth: expandWidth,
                  ),
                  leftPinnedTable: leftPinnedEntries.isNotEmpty
                      ? _buildSection(
                          entries: leftPinnedEntries,
                          isPinned: true,
                          vController: _controller.vStartController,
                          showScrollbar: false,
                        )
                      : null,
                  rightPinnedTable: rightPinnedEntries.isNotEmpty
                      ? _buildSection(
                          entries: rightPinnedEntries,
                          isPinned: true,
                          isRightSection: true,
                          vController: _controller.vEndController,
                          showScrollbar: true,
                        )
                      : null,
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

  Widget _buildSection({
    required List<(int, TableColumn<T>)> entries,
    required ScrollController? vController,
    bool isPinned = false,
    bool isRightSection = false,
    bool showScrollbar = true,
    double? availableWidth,
  }) {
    final columnWidths = <int, TableColumnWidth>{};
    final hasFlex = entries.any((e) => e.$2.flex != null);
    final shouldExpand = widget.expand && !isPinned && availableWidth != null;

    for (var i = 0; i < entries.length; i++) {
      final index = entries[i].$1;
      final column = entries[i].$2;
      final width = _controller.columnWidths[index] ??
          column.width ??
          100.0;

      if (shouldExpand) {
        if (column.flex != null) {
          columnWidths[i] = FlexColumnWidth(column.flex!.toDouble());
        } else if (!hasFlex) {
          // If no columns have flex, but table should expand, make all columns flexible
          columnWidths[i] = const FlexColumnWidth();
        } else {
          columnWidths[i] = FixedColumnWidth(width);
        }
      } else {
        columnWidths[i] = FixedColumnWidth(width);
      }
    }

    final headers = <Widget>[
      ...List.generate(entries.length, (i) {
        final index = entries[i].$1;
        final column = entries[i].$2;
        return YuhuTableDraggableHeader<T>(
          index: index,
          column: column,
          isSort: _controller.sortIndex == index,
          ascending: _controller.ascending,
          pinnedPosition: _controller.pinnedLeft.contains(index)
              ? TablePinPosition.left
              : (_controller.pinnedRight.contains(index)
                  ? TablePinPosition.right
                  : TablePinPosition.none),
          currentWidth:
              _controller.columnWidths[index] ?? column.width ?? 100.0,
          headerDecoration: _style.headerDecoration,
          onPinnedPositionChanged: (p) => setState(() {
            _controller.pinnedLeft.remove(index);
            _controller.pinnedRight.remove(index);
            if (p == TablePinPosition.left) {
              _controller.pinnedLeft.add(index);
            } else if (p == TablePinPosition.right) {
              _controller.pinnedRight.add(index);
            }
          }),
          onColorChanged: (color) => setState(() {
            _controller.columnColors[index] = color;
          }),
          onResizing: (delta) {
            setState(() {
              final currentWidth =
                  _controller.columnWidths[index] ?? column.width ?? 100.0;
              _controller.columnWidths[index] =
                  (currentWidth + delta).clamp(50.0, 1000.0);
            });
          },
          onTap: () {
            if (column.sortNum == null && column.sortString == null) {
              widget.onSort?.call(index, !_controller.ascending);
            } else {
              setState(() {
                if (_controller.sortIndex != index) {
                  _controller.sortIndex = index;
                  _controller.ascending = true;
                } else {
                  _controller.ascending = !_controller.ascending;
                }
              });
            }
          },
          onDrop: (fromIndex) {
            setState(() {
              if (_controller.pinnedLeft.contains(index)) {
                _controller.pinnedLeft.add(fromIndex);
                _controller.pinnedRight.remove(fromIndex);
              } else if (_controller.pinnedRight.contains(index)) {
                _controller.pinnedRight.add(fromIndex);
                _controller.pinnedLeft.remove(fromIndex);
              } else {
                _controller.pinnedLeft.remove(fromIndex);
                _controller.pinnedRight.remove(fromIndex);
              }

              final oldPos = _controller.columnOrder.indexOf(fromIndex);
              final newPos = _controller.columnOrder.indexOf(index);
              if (oldPos != -1 && newPos != -1) {
                _controller.columnOrder
                  ..removeAt(oldPos)
                  ..insert(newPos, fromIndex);
              }
            });
          },
        );
      }),
    ];

    if (!isPinned && widget.onSelectChanged != null) {
      columnWidths[entries.length] = const FixedColumnWidth(80);
      headers.add(
        TableHeader<T>(
          column: TableColumn<T>(title: '', builder: (_, __) => Container()),
          isSort: false,
          ascending: _controller.ascending,
        ),
      );
    }

    final rows = YuhuTableRowsGenerator.generate<T>(
      data: widget.data,
      entries: entries,
      rowHeight: widget.rowHeight,
      rowsPerPage: widget.rowsPerPage,
      baseColor: _style.theme.cardColor,
      stripedColor: _style.stripedColor,
      hoverColor: _style.hoverColor,
      borderSide: _style.borderSide,
      hoveredRowIndex: _controller.hoveredRowIndex,
      columnColors: _controller.columnColors,
      enableHoverEffect: true,
      onHoverEnter: (int rowIndex) {
        if (_controller.hoveredRowIndex != rowIndex) {
          setState(() => _controller.hoveredRowIndex = rowIndex);
        }
      },
      onHoverExit: () {
        if (_controller.hoveredRowIndex != null) {
          setState(() => _controller.hoveredRowIndex = null);
        }
      },
      selectionCheckboxBuilder: widget.onSelectChanged == null
          ? null
          : (rowIndex, item) => TableData(
                height: widget.rowHeight,
                alignment: Alignment.center,
                borderSide: _style.borderSide,
                showRightBorder: true,
                child: Checkbox(
                  value: _controller.selected.contains(item),
                  onChanged: (value) => setState(() {
                    _controller.handleSelection(item, widget.onSelectChanged);
                  }),
                ),
              ),
      selectionEmptyBuilder: widget.onSelectChanged == null
          ? null
          : (rowIndex) => TableData(
                height: widget.rowHeight,
                alignment: Alignment.center,
                borderSide: _style.borderSide,
                showRightBorder: true,
                child: Container(),
              ),
      isPinned: isPinned,
    );

    return SizedBox(
      width: shouldExpand ? availableWidth : null,
      child: YuhuTableSection(
        columnWidths: columnWidths,
        headers: headers,
        rows: rows,
        borderSide: _style.borderSide,
        headerDecoration: _style.headerDecoration,
        bodyHeight: widget.bodyHeight,
        vController: vController,
        showScrollbar: showScrollbar,
        alignment:
            isRightSection ? Alignment.centerRight : Alignment.centerLeft,
        decoration: isPinned
            ? BoxDecoration(
                color: _style.theme.cardColor,
                border: Border(
                  left: isRightSection ? _style.borderSide : BorderSide.none,
                  right: !isRightSection ? _style.borderSide : BorderSide.none,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .04),
                    blurRadius: 10,
                    offset: Offset(isRightSection ? -4 : 4, 0),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
