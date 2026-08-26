import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

class TableWithoutHeader<T> extends StatefulWidget {
  const TableWithoutHeader({
    required this.data,
    required this.columns,
    this.width,
    super.key,
    this.onSelectChanged,
    this.rowHeight = 48,
    this.status = Status.loaded,
    this.showBorder = true,
    this.scrollController,
  });
  final double rowHeight;
  final Status status;
  final List<T> data;
  final double? width;
  final void Function(List<T>)? onSelectChanged;
  final bool showBorder;
  final List<BodyColumn<T>> columns;
  final ScrollController? scrollController;

  @override
  State<TableWithoutHeader<T>> createState() => _TableWithoutHeader<T>();
}

class _TableWithoutHeader<T> extends State<TableWithoutHeader<T>> {
  int? _sortColumnIndex;
  final bool _sortAscending = true;
  final List<T> _selected = [];

  @override
  void initState() {
    super.initState();
  }

  List<T> _sort() {
    if (_sortColumnIndex == null) return widget.data;

    final sortStringFunction = widget.columns[_sortColumnIndex!].sortString;
    final sortNumFunction = widget.columns[_sortColumnIndex!].sortNum;

    if (sortStringFunction != null) {
      return sortString(widget.data, sortStringFunction, _sortAscending);
    }

    if (sortNumFunction != null) {
      return sortNum(widget.data, sortNumFunction, _sortAscending);
    }

    return widget.data;
  }

  @override
  Widget build(BuildContext context) {
    final data = _sort();
    final columnWidths = <int, TableColumnWidth>{};
    for (var i = 0; i < widget.columns.length; i++) {
      final width = widget.columns[i].width;
      if (width != null) {
        columnWidths[i] = FixedColumnWidth(width);
      }
    }

    final Widget table = Table(
      columnWidths: columnWidths,
      children: [
        ...List.generate(
          data.length,
          (row) {
            final columns = List.generate(
              widget.columns.length,
              (column) => _TableData(
                showBorder: widget.showBorder,
                height: widget.rowHeight,
                alignment: widget.columns[column].alignment,
                child: widget.columns[column].builder(data[row], row),
              ),
            );
            if (widget.onSelectChanged != null) {
              columnWidths[widget.columns.length] = const FixedColumnWidth(80);
              final selected = _selected.contains(widget.data[row]);
              columns.add(
                _TableData(
                  showBorder: widget.showBorder,
                  height: widget.rowHeight,
                  alignment: Alignment.center,
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
        ),
      ],
    );

    return Column(
      children: [
        Row(
          children: [
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
                    controller: widget.scrollController ?? scrollController,
                    interactive: true,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: widget.scrollController ?? scrollController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(width: width, child: table),
                    ),
                  );
                },
              ),
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
}

class BodyColumn<T> {
  BodyColumn({
    required this.builder,
    this.sortString,
    this.sortNum,
    this.alignment = Alignment.centerLeft,
    this.width,
  });

  final Alignment alignment;
  final double? width;
  final String Function(T)? sortString;
  final num Function(T)? sortNum;
  final Widget Function(T, int) builder;
}

class _TableData extends StatelessWidget {
  const _TableData({
    required this.child,
    required this.height,
    required this.alignment,
    required this.showBorder,
  });

  final Widget child;
  final double height;
  final Alignment alignment;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: showBorder
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            )
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Align(
        alignment: alignment,
        child: child,
      ),
    );
  }
}
