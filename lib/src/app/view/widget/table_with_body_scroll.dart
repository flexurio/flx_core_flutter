import 'package:flutter/material.dart';

class TableWithBodyScroll extends StatelessWidget {
  const TableWithBodyScroll({
    required this.children,
    super.key,
    this.columnWidths,
    this.heightBody,
    this.maxHeightBody,
    this.border,
    this.controller,
    this.physics,
    this.showScrollbar = true,
    this.defaultVerticalAlignment = TableCellVerticalAlignment.middle,
  });

  final Map<int, TableColumnWidth>? columnWidths;
  final List<TableRow> children;
  final double? heightBody;
  final double? maxHeightBody;
  final TableBorder? border;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool showScrollbar;
  final TableCellVerticalAlignment defaultVerticalAlignment;

  @override
  Widget build(BuildContext context) {
    if (heightBody == null && maxHeightBody == null) {
      return Table(
        columnWidths: columnWidths,
        defaultVerticalAlignment: defaultVerticalAlignment,
        border: border,
        children: children,
      );
    }

    final headerRow = children.isNotEmpty ? children.first : null;
    final bodyRows = children.length > 1 ? children.sublist(1) : <TableRow>[];

    final bodyTable = SingleChildScrollView(
      controller: controller,
      physics: physics,
      child: Table(
        columnWidths: columnWidths,
        defaultVerticalAlignment: defaultVerticalAlignment,
        border: border,
        children: bodyRows,
      ),
    );

    Widget scrollableBody = showScrollbar
        ? Scrollbar(
            controller: controller,
            thumbVisibility: true,
            child: bodyTable,
          )
        : bodyTable;

    if (maxHeightBody != null) {
      scrollableBody = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeightBody!),
        child: scrollableBody,
      );
    } else if (heightBody != null) {
      scrollableBody = SizedBox(
        height: heightBody,
        child: scrollableBody,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: columnWidths,
          defaultVerticalAlignment: defaultVerticalAlignment,
          border: border,
          children: [if (headerRow != null) headerRow],
        ),
        scrollableBody,
      ],
    );
  }
}
