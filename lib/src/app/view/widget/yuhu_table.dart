import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TableColumn<T> {
  TableColumn({
    required this.title,
    required this.builder,
    this.sortString,
    this.sortNum,
    this.alignment = Alignment.centerLeft,
    this.width,
  });

  final String title;
  final Alignment alignment;
  final double? width;
  final String Function(T)? sortString;
  final num Function(T)? sortNum;
  final Widget Function(T, int) builder;
}

class YuhuTable<T> extends StatefulWidget {
  const YuhuTable({
    required this.data,
    required this.columns,
    this.width,
    this.rowsPerPage,
    super.key,
    this.onSelectChanged,
    this.rowHeight = 48,
    this.status = Status.loaded,
    this.onSort,
    this.initialSortColumnIndex,
    this.initialSortAscending,
    this.freezeFirstColumn = false,
    this.freezeLastColumn = false,
  });
  final int? initialSortColumnIndex;
  final bool? initialSortAscending;
  final void Function(int, bool)? onSort;
  final double rowHeight;
  final Status status;
  final int? rowsPerPage;
  final List<T> data;
  final double? width;
  final void Function(List<T>)? onSelectChanged;
  final bool freezeFirstColumn;
  final bool freezeLastColumn;
  final List<TableColumn<T>> columns;

  @override
  State<YuhuTable<T>> createState() => _YuhuTableState<T>();
}

class _YuhuTableState<T> extends State<YuhuTable<T>> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  late List<TableColumn<T>> _dataColumn;
  TableColumn<T>? freezeFirstColumn;
  TableColumn<T>? freezeLastColumn;
  final List<T> _selected = [];

  @override
  void initState() {
    super.initState();
    _dataColumn = widget.columns;

    if (widget.freezeFirstColumn) {
      freezeFirstColumn = _dataColumn.first;
      _dataColumn.removeAt(0);
    }

    if (widget.freezeLastColumn) {
      freezeLastColumn = _dataColumn.last;
      _dataColumn.removeLast();
    }

    if (widget.initialSortColumnIndex != null) {
      _sortColumnIndex = widget.initialSortColumnIndex;
    }

    if (widget.initialSortAscending != null) {
      _sortAscending = widget.initialSortAscending!;
    }
  }

  _TableHeader<T> _buildTableHeader(int index, TableColumn<T> column) {
    return _TableHeader(
      column: column,
      onTap: column.sortNum == null && column.sortString == null
          ? (widget.onSort != null
              ? () => widget.onSort!(index, !_sortAscending)
              : null)
          : () {
              if (_sortColumnIndex != index) {
                _sortColumnIndex = index;
                _sortAscending = true;
              } else {
                _sortAscending = !_sortAscending;
              }
              setState(() {});
            },
      ascending: _sortAscending,
      isSort: _sortColumnIndex == index,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final borderSide = BorderSide(
      color: theme.brightness == Brightness.dark
          ? MyTheme.black06dp
          : Colors.grey.shade300,
    );

    final data = widget.data;
    final columnWidths = <int, TableColumnWidth>{};
    for (var i = 0; i < _dataColumn.length; i++) {
      final width = _dataColumn[i].width;
      if (width != null) {
        columnWidths[i] = FixedColumnWidth(width);
      }
    }

    final columns = List.generate(
      _dataColumn.length,
      (index) {
        final column = _dataColumn[index];
        return _buildTableHeader(
          widget.freezeFirstColumn ? index + 1 : index,
          column,
        );
      },
    );
    if (widget.onSelectChanged != null) {
      columnWidths[_dataColumn.length] = const FixedColumnWidth(80);
      columns.add(
        _TableHeader(
          column: TableColumn(
            builder: (p0, p1) {
              return Container();
            },
            title: '',
          ),
          onTap: () {},
          ascending: _sortAscending,
          isSort: false,
        ),
      );
    }

    final dataBody = List.generate(
      data.length,
      (row) {
        final columns = List.generate(
          _dataColumn.length,
          (column) => _TableData(
            height: widget.rowHeight,
            alignment: _dataColumn[column].alignment,
            borderSide: borderSide,
            child: _dataColumn[column].builder(data[row], row),
          ),
        );
        if (widget.onSelectChanged != null) {
          final selected = _selected.contains(widget.data[row]);
          columns.add(
            _TableData(
              height: widget.rowHeight,
              alignment: Alignment.center,
              borderSide: borderSide,
              child: Checkbox(
                value: selected,
                onChanged: (value) {
                  if (value != null && value) {
                    _selected.add(data[row]);
                  } else {
                    _selected.remove(data[row]);
                  }

                  setState(() {});
                  widget.onSelectChanged?.call(_selected);
                },
              ),
            ),
          );
        }

        return TableRow(children: columns);
      },
    );

    if (widget.rowsPerPage != null && dataBody.length < widget.rowsPerPage!) {
      dataBody.addAll(
        List.generate(
          widget.rowsPerPage! - dataBody.length,
          (index) => TableRow(
            children: List.generate(
              _dataColumn.length,
              (column) => _TableData(
                height: widget.rowHeight,
                alignment: _dataColumn[column].alignment,
                borderSide: borderSide,
                child: Container(),
              ),
            ),
          ),
        ),
      );
    }

    final boxDecorationHeader = BoxDecoration(
      color: theme.brightness == Brightness.dark
          ? primaryColor.darken(.3)
          : primaryColor.lighten(.5),
    );

    final Widget table = Table(
      columnWidths: columnWidths,
      border: TableBorder(
        verticalInside:
            borderSide.copyWith(color: borderSide.color.withOpacity(.4)),
      ),
      children: [
        TableRow(
          decoration: boxDecorationHeader,
          children: columns,
        ),
        ...dataBody,
      ],
    );

    return Column(
      children: [
        Stack(
          children: [
            Row(
              children: [
                Gap(freezeFirstColumn?.width ?? 0),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final scrollController = ScrollController();
                      final maxWidth = constraints.maxWidth;
                      var width = widget.width ?? maxWidth;
                      if (width < maxWidth) {
                        width = maxWidth;
                      }
                      return Scrollbar(
                        controller: scrollController,
                        interactive: true,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(width: width, child: table),
                        ),
                      );
                    },
                  ),
                ),
                Gap(freezeLastColumn?.width ?? 0),
              ],
            ),
            if (widget.freezeFirstColumn)
              _buildFreezedColumn(
                boxDecorationHeader,
                data,
                freezeFirstColumn!,
                false,
                theme,
                borderSide,
              ),
            if (widget.freezeLastColumn)
              _buildFreezedColumn(
                boxDecorationHeader,
                data,
                freezeLastColumn!,
                true,
                theme,
                borderSide,
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
  }

  Widget _buildFreezedColumn(
    BoxDecoration boxDecorationHeader,
    List<T> data,
    TableColumn<T> freezeColumn,
    bool isLast,
    ThemeData theme,
    BorderSide borderSide,
  ) {
    final dataBody = List.generate(
      data.length,
      (row) => TableRow(
        decoration: BoxDecoration(color: theme.cardColor),
        children: [
          _TableData(
            height: widget.rowHeight,
            alignment: freezeColumn.alignment,
            borderSide: borderSide,
            child: freezeColumn.builder(data[row], row),
          ),
        ],
      ),
    );
    if (widget.rowsPerPage != null && dataBody.length < widget.rowsPerPage!) {
      dataBody.addAll(
        List.generate(
          widget.rowsPerPage! - dataBody.length,
          (index) => TableRow(
            decoration: BoxDecoration(color: theme.cardColor),
            children: [
              _TableData(
                height: widget.rowHeight,
                alignment: freezeColumn.alignment,
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
              EdgeInsets.only(right: isLast ? 0 : 30, left: isLast ? 30 : 0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: theme.modeCondition(Colors.black12, Colors.black54),
                blurRadius: 5,
                offset: Offset(isLast ? -3 : 3, -2),
              ),
            ],
          ),
          child: Table(
            columnWidths: {
              0: FixedColumnWidth(freezeColumn.width ?? 0),
            },
            children: [
              TableRow(
                decoration: boxDecorationHeader,
                children: [_buildTableHeader(0, freezeColumn)],
              ),
              ...dataBody,
            ],
          ),
        ),
      ),
    );
  }
}

class _TableHeader<T> extends StatelessWidget {
  const _TableHeader({
    required this.column,
    required this.isSort,
    required this.ascending,
    this.onTap,
  });

  final TableColumn<T> column;
  final void Function()? onTap;
  final bool isSort;
  final bool ascending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Align(
          alignment: column.alignment,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                column.title,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
              ),
              if (isSort)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(
                    ascending ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 16,
                    color: primaryColor.withOpacity(.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableData extends StatelessWidget {
  const _TableData({
    required this.child,
    required this.height,
    required this.alignment,
    required this.borderSide,
  });

  final Widget child;
  final double height;
  final Alignment alignment;
  final BorderSide borderSide;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border(
          bottom: borderSide,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Align(
        alignment: alignment,
        child: child,
      ),
    );
  }
}
