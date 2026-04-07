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
    this.disableModify = false,
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
  final bool disableModify;

  @override
  State<YuhuTable<T>> createState() => _YuhuTableState<T>();
}

class _YuhuTableState<T> extends State<YuhuTable<T>> {
  late final YuhuTableController<T> _controller;

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
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
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
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = YuhuTableStyle(context);

    return ScreenIdentifierBuilder(
      builder: (context, screenIdentifier) {
        final isSmall =
            screenIdentifier.conditions(md: false, sm: true) == true ||
                MediaQuery.sizeOf(context).width < 1000;

        final leftPinnedEntries = _controller.getFilteredEntries(
          widget.columns,
          isSmall,
          isPinnedLeft: true,
        );
        final centerPinnedEntries = _controller.getFilteredEntries(
          widget.columns,
          isSmall,
        );
        final rightPinnedEntries = _controller.getFilteredEntries(
          widget.columns,
          isSmall,
          isPinnedRight: true,
        );

        final startWidth = _controller.calculateWidth(leftPinnedEntries, false);
        final endWidth = _controller.calculateWidth(rightPinnedEntries, false);
        final totalCenterWidth = _controller.calculateWidth(
          centerPinnedEntries,
          widget.onSelectChanged != null,
        );

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
                  decoration: style.containerDecoration,
                  horizontalScrollController:
                      _controller.horizontalScrollController,
                  centerTable: _buildSection(
                    entries: centerPinnedEntries,
                    vController: _controller.vMiddleController,
                    showScrollbar: rightPinnedEntries.isEmpty,
                    availableWidth: expandWidth,
                    style: style,
                  ),
                  leftPinnedTable: leftPinnedEntries.isNotEmpty
                      ? _buildSection(
                          entries: leftPinnedEntries,
                          isPinned: true,
                          vController: _controller.vStartController,
                          showScrollbar: false,
                          style: style,
                        )
                      : null,
                  rightPinnedTable: rightPinnedEntries.isNotEmpty
                      ? _buildSection(
                          entries: rightPinnedEntries,
                          isPinned: true,
                          isRightSection: true,
                          vController: _controller.vEndController,
                          showScrollbar: true,
                          style: style,
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
    required YuhuTableStyle style,
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
      final width = _controller.columnWidths[index] ?? column.width ?? 100.0;
      final hasManualWidth = _controller.columnWidths.containsKey(index);

      if (shouldExpand) {
        if (column.flex != null) {
          columnWidths[i] = FlexColumnWidth(column.flex!.toDouble());
        } else if (!hasFlex && !hasManualWidth && column.width == null) {
          // Only make it flexible if no columns have flex, 
          // AND it doesn't have a manual resize,
          // AND it doesn't have a defined width.
          columnWidths[i] = const FlexColumnWidth();
        } else {
          columnWidths[i] = FixedColumnWidth(width);
        }
      } else {
        columnWidths[i] = FixedColumnWidth(width);
      }
    }

    final List<Widget> headers = entries.map((entry) {
      final index = entry.$1;
      final column = entry.$2;
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
        currentWidth: _controller.columnWidths[index] ?? column.width ?? 100.0,
        headerDecoration: style.headerDecoration,
        disableModify: widget.disableModify,
        onPinnedPositionChanged: (p) => _controller.togglePin(index, p),
        onColorChanged: (color) => _controller.updateColumnColor(index, color),
        onResizing: (delta) => _controller.updateColumnWidth(index, delta),
        onTap: widget.disableModify
            ? null
            : () {
                if (column.sortNum == null && column.sortString == null) {
                  widget.onSort?.call(index, !_controller.ascending);
                } else {
                  if (_controller.sortIndex != index) {
                    _controller.sortIndex = index;
                    _controller.ascending = true;
                  } else {
                    _controller.ascending = !_controller.ascending;
                  }
                }
              },
        onDrop: (fromIndex) => _controller.reorderColumns(fromIndex, index),
      );
    }).toList();

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
      baseColor: style.theme.cardColor,
      stripedColor: style.stripedColor,
      hoverColor: style.hoverColor,
      borderSide: style.borderSide,
      hoveredRowIndex: _controller.hoveredRowIndex,
      columnColors: _controller.columnColors,
      enableHoverEffect: true,
      onHoverEnter: (int rowIndex) => _controller.hoveredRowIndex = rowIndex,
      onHoverExit: () => _controller.hoveredRowIndex = null,
      selectionCheckboxBuilder: widget.onSelectChanged == null
          ? null
          : (rowIndex, item) => TableData(
                height: widget.rowHeight,
                alignment: Alignment.center,
                borderSide: style.borderSide,
                showRightBorder: true,
                child: Checkbox(
                  value: _controller.selected.contains(item),
                  onChanged: (value) =>
                      _controller.handleSelection(item, widget.onSelectChanged),
                ),
              ),
      selectionEmptyBuilder: widget.onSelectChanged == null
          ? null
          : (rowIndex) => TableData(
                height: widget.rowHeight,
                alignment: Alignment.center,
                borderSide: style.borderSide,
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
        borderSide: style.borderSide,
        headerDecoration: style.headerDecoration,
        bodyHeight: widget.bodyHeight,
        vController: vController,
        showScrollbar: showScrollbar,
        alignment:
            isRightSection ? Alignment.centerRight : Alignment.centerLeft,
        decoration: isPinned
            ? BoxDecoration(
                color: style.theme.cardColor,
                border: Border(
                  left: isRightSection ? style.borderSide : BorderSide.none,
                  right: !isRightSection ? style.borderSide : BorderSide.none,
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

