import 'package:flutter/material.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/table_column.dart';

class YuhuTableController<T> {
  int? sortIndex;
  bool ascending = true;
  final List<T> selected = [];

  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController vMiddleController = ScrollController();
  final ScrollController vStartController = ScrollController();
  final ScrollController vEndController = ScrollController();

  int? hoveredRowIndex;
  bool isSyncing = false;

  final Set<int> pinnedLeft = {};
  final Set<int> pinnedRight = {};
  final Map<int, double> columnWidths = {};
  final Map<int, Color?> columnColors = {};
  List<int> columnOrder = [];

  void init(
    List<TableColumn<T>> columns, {
    int? initialSortColumnIndex,
    bool? initialSortAscending,
    bool freezeFirstColumn = false,
    bool freezeLastColumn = false,
    required VoidCallback onSyncScroll,
  }) {
    sortIndex = initialSortColumnIndex;
    ascending = initialSortAscending ?? true;
    columnOrder = List.generate(columns.length, (index) => index);

    if (freezeFirstColumn) pinnedLeft.add(0);
    if (freezeLastColumn && columns.isNotEmpty) {
      pinnedRight.add(columns.length - 1);
    }

    for (var i = 0; i < columns.length; i++) {
      if (columns[i].width != null) {
        columnWidths[i] = columns[i].width!;
      }
    }

    vMiddleController.addListener(onSyncScroll);
    vStartController.addListener(onSyncScroll);
    vEndController.addListener(onSyncScroll);
  }

  void syncScroll(ScrollController source) {
    if (isSyncing) return;
    isSyncing = true;
    final offset = source.offset;
    if (vMiddleController.hasClients &&
        vMiddleController != source &&
        vMiddleController.offset != offset) {
      vMiddleController.jumpTo(offset);
    }
    if (vStartController.hasClients &&
        vStartController != source &&
        vStartController.offset != offset) {
      vStartController.jumpTo(offset);
    }
    if (vEndController.hasClients &&
        vEndController != source &&
        vEndController.offset != offset) {
      vEndController.jumpTo(offset);
    }
    isSyncing = false;
  }

  void dispose() {
    horizontalScrollController.dispose();
    vMiddleController.dispose();
    vStartController.dispose();
    vEndController.dispose();
  }

  void update({
    required List<TableColumn<T>> columns,
    required List<TableColumn<T>> oldColumns,
    int? initialSortColumnIndex,
    int? oldInitialSortColumnIndex,
    bool? initialSortAscending,
    bool? oldInitialSortAscending,
    bool freezeFirstColumn = false,
    bool oldFreezeFirstColumn = false,
    bool freezeLastColumn = false,
    bool oldFreezeLastColumn = false,
  }) {
    if (initialSortColumnIndex != oldInitialSortColumnIndex) {
      sortIndex = initialSortColumnIndex;
    }
    if (initialSortAscending != oldInitialSortAscending) {
      ascending = initialSortAscending ?? true;
    }
    if (freezeFirstColumn != oldFreezeFirstColumn) {
      if (freezeFirstColumn) {
        pinnedLeft.add(0);
      } else {
        pinnedLeft.remove(0);
      }
    }
    if (freezeLastColumn != oldFreezeLastColumn) {
      if (freezeLastColumn && columns.isNotEmpty) {
        pinnedRight.add(columns.length - 1);
      } else {
        pinnedRight.remove(columns.length - 1);
      }
    }

    if (columns.length != oldColumns.length) {
      final newIndices = List.generate(columns.length, (index) => index);
      final keptOrder = columnOrder.where((i) => i < columns.length).toList();
      final addedIndices =
          newIndices.where((i) => !columnOrder.contains(i)).toList();
      columnOrder = [...keptOrder, ...addedIndices];
    }
  }

  void handleSelection(T item, void Function(List<T>)? onSelectChanged) {
    if (selected.contains(item)) {
      selected.remove(item);
    } else {
      selected.add(item);
    }
    onSelectChanged?.call(selected);
  }
}
