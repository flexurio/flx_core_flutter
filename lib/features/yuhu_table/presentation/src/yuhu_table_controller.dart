import 'package:flutter/material.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/table_column.dart';

class YuhuTableController<T> extends ChangeNotifier {
  int? _sortIndex;
  int? get sortIndex => _sortIndex;
  set sortIndex(int? value) {
    if (_sortIndex != value) {
      _sortIndex = value;
      notifyListeners();
    }
  }

  bool _ascending = true;
  bool get ascending => _ascending;
  set ascending(bool value) {
    if (_ascending != value) {
      _ascending = value;
      notifyListeners();
    }
  }

  final List<T> selected = [];

  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController vMiddleController = ScrollController();
  final ScrollController vStartController = ScrollController();
  final ScrollController vEndController = ScrollController();

  int? _hoveredRowIndex;
  int? get hoveredRowIndex => _hoveredRowIndex;
  set hoveredRowIndex(int? value) {
    if (_hoveredRowIndex != value) {
      _hoveredRowIndex = value;
      notifyListeners();
    }
  }

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
    _sortIndex = initialSortColumnIndex;
    _ascending = initialSortAscending ?? true;
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

  @override
  void dispose() {
    horizontalScrollController.dispose();
    vMiddleController.dispose();
    vStartController.dispose();
    vEndController.dispose();
    super.dispose();
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
    bool changed = false;

    if (initialSortColumnIndex != oldInitialSortColumnIndex) {
      _sortIndex = initialSortColumnIndex;
      changed = true;
    }
    if (initialSortAscending != oldInitialSortAscending) {
      _ascending = initialSortAscending ?? true;
      changed = true;
    }
    if (freezeFirstColumn != oldFreezeFirstColumn) {
      if (freezeFirstColumn) {
        pinnedLeft.add(0);
      } else {
        pinnedLeft.remove(0);
      }
      changed = true;
    }
    if (freezeLastColumn != oldFreezeLastColumn) {
      if (freezeLastColumn && columns.isNotEmpty) {
        pinnedRight.add(columns.length - 1);
      } else {
        pinnedRight.remove(columns.length - 1);
      }
      changed = true;
    }

    if (columns.length != oldColumns.length) {
      final newIndices = List.generate(columns.length, (index) => index);
      final keptOrder = columnOrder.where((i) => i < columns.length).toList();
      final addedIndices =
          newIndices.where((i) => !columnOrder.contains(i)).toList();
      columnOrder = [...keptOrder, ...addedIndices];
      changed = true;
    }

    if (changed) notifyListeners();
  }

  void handleSelection(T item, void Function(List<T>)? onSelectChanged) {
    if (selected.contains(item)) {
      selected.remove(item);
    } else {
      selected.add(item);
    }
    onSelectChanged?.call(List.from(selected));
    notifyListeners();
  }

  void togglePin(int index, TablePinPosition position) {
    pinnedLeft.remove(index);
    pinnedRight.remove(index);
    if (position == TablePinPosition.left) {
      pinnedLeft.add(index);
    } else if (position == TablePinPosition.right) {
      pinnedRight.add(index);
    }
    notifyListeners();
  }

  void updateColumnColor(int index, Color? color) {
    columnColors[index] = color;
    notifyListeners();
  }

  void updateColumnWidth(int index, double delta) {
    final currentWidth = columnWidths[index] ?? 100.0;
    columnWidths[index] = (currentWidth + delta).clamp(50.0, 1000.0);
    notifyListeners();
  }

  void reorderColumns(int fromIndex, int toIndex) {
    if (pinnedLeft.contains(toIndex)) {
      pinnedLeft.add(fromIndex);
      pinnedRight.remove(fromIndex);
    } else if (pinnedRight.contains(toIndex)) {
      pinnedRight.add(fromIndex);
      pinnedLeft.remove(fromIndex);
    } else {
      pinnedLeft.remove(fromIndex);
      pinnedRight.remove(fromIndex);
    }

    final oldPos = columnOrder.indexOf(fromIndex);
    final newPos = columnOrder.indexOf(toIndex);
    if (oldPos != -1 && newPos != -1) {
      columnOrder
        ..removeAt(oldPos)
        ..insert(newPos, fromIndex);
    }
    notifyListeners();
  }

  List<(int, TableColumn<T>)> getFilteredEntries(
    List<TableColumn<T>> columns,
    bool isSmall, {
    bool? isPinnedLeft,
    bool? isPinnedRight,
  }) {
    final entries = <(int, TableColumn<T>)>[];
    for (final i in columnOrder) {
      if (i >= columns.length) continue;
      final entry = (i, columns[i]);
      final isLeft = pinnedLeft.contains(i);
      final isRight = pinnedRight.contains(i);

      if (isSmall) {
        if (isPinnedLeft == null && isPinnedRight == null) {
          entries.add(entry);
        }
      } else {
        if (isPinnedLeft == true && isLeft) {
          entries.add(entry);
        } else if (isPinnedRight == true && isRight) {
          entries.add(entry);
        } else if (isPinnedLeft == null &&
            isPinnedRight == null &&
            !isLeft &&
            !isRight) {
          entries.add(entry);
        }
      }
    }
    return entries;
  }

  double calculateWidth(
    List<(int, TableColumn<T>)> entries,
    bool includeSelection,
  ) {
    return entries.fold<double>(
          0.0,
          (p, c) => p + (columnWidths[c.$1] ?? c.$2.width ?? 100.0),
        ) +
        (includeSelection ? 80.0 : 0.0);
  }
}
