import 'package:flutter/material.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/table_column.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/table_data.dart';

class YuhuTableRowsGenerator<T> {
  static List<TableRow> generate<T>({
    required List<T> data,
    required List<(int, TableColumn<T>)> entries,
    required double rowHeight,
    required int? rowsPerPage,
    required Color baseColor,
    required Color stripedColor,
    required Color hoverColor,
    required BorderSide borderSide,
    required int? hoveredRowIndex,
    required Map<int, Color?> columnColors,
    required bool enableHoverEffect,
    required void Function(int rowIndex) onHoverEnter,
    required VoidCallback onHoverExit,
    required Widget Function(int rowIndex, T item)? selectionCheckboxBuilder,
    required Widget Function(int rowIndex)? selectionEmptyBuilder,
    bool isPinned = false,
  }) {
    final rows = List<TableRow>.generate(data.length, (rowIndex) {
      final isHovered = enableHoverEffect && hoveredRowIndex == rowIndex;
      final rowColor = isHovered
          ? hoverColor
          : (rowIndex % 2 != 0 ? stripedColor : baseColor);

      final cells = <Widget>[
        for (var i = 0; i < entries.length; i++)
          TableData(
            height: rowHeight,
            alignment: entries[i].$2.alignment,
            borderSide: borderSide,
            showRightBorder: true,
            backgroundColor:
                columnColors[entries[i].$1] ?? entries[i].$2.backgroundColor,
            child: entries[i].$2.builder(data[rowIndex], rowIndex),
          ),
      ];

      if (!isPinned && selectionCheckboxBuilder != null) {
        cells.add(selectionCheckboxBuilder(rowIndex, data[rowIndex]));
      }

      return TableRow(
        decoration: BoxDecoration(color: rowColor),
        children: cells.map((child) {
          if (!enableHoverEffect) return child;
          return MouseRegion(
            hitTestBehavior: HitTestBehavior.opaque,
            onEnter: (_) => onHoverEnter(rowIndex),
            onExit: (_) => onHoverExit(),
            child: ColoredBox(color: Colors.transparent, child: child),
          );
        }).toList(),
      );
    });

    if (rowsPerPage != null && rows.length < rowsPerPage) {
      final emptyRowsCount = rowsPerPage - rows.length;
      rows.addAll(
        List.generate(emptyRowsCount, (emptyIndex) {
          final rowIndex = data.length + emptyIndex;
          final isHovered = enableHoverEffect && hoveredRowIndex == rowIndex;
          final rowColor = isHovered
              ? hoverColor
              : (rowIndex % 2 != 0 ? stripedColor : baseColor);

          final cells = <Widget>[
            for (var i = 0; i < entries.length; i++)
              TableData(
                height: rowHeight,
                alignment: entries[i].$2.alignment,
                borderSide: borderSide,
                showRightBorder: true,
                backgroundColor: columnColors[entries[i].$1] ??
                    entries[i].$2.backgroundColor,
                child: Container(),
              ),
          ];

          if (!isPinned && selectionEmptyBuilder != null) {
            cells.add(selectionEmptyBuilder(rowIndex));
          }

          return TableRow(
            decoration: BoxDecoration(color: rowColor),
            children: cells.map((child) {
              if (!enableHoverEffect) return child;
              return MouseRegion(
                hitTestBehavior: HitTestBehavior.opaque,
                onEnter: (_) => onHoverEnter(rowIndex),
                onExit: (_) => onHoverExit(),
                child: ColoredBox(color: Colors.transparent, child: child),
              );
            }).toList(),
          );
        }),
      );
    }
    return rows;
  }
}
