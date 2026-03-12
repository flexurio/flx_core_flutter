import 'package:flutter/material.dart';

class TableWithBodyScroll extends StatelessWidget {
  // Add the border parameter

  const TableWithBodyScroll({
    required this.children,
    super.key,
    this.columnWidths,
    this.heightBody,
    this.border,
    this.controller,
    this.physics,
    this.showScrollbar = true,
  });
  final Map<int, TableColumnWidth>? columnWidths;
  final List<TableRow> children;
  final double? heightBody;
  final TableBorder? border;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool showScrollbar;

  @override
  Widget build(BuildContext context) {
    if (heightBody == null) {
      return Table(
        columnWidths: columnWidths,
        children: children,
        border: border, // Apply the border to the table
      );
    }

    final headerRow = children.isNotEmpty ? children.first : null;
    final bodyRows = children.length > 1 ? children.sublist(1) : <TableRow>[];

    final bodyTable = SingleChildScrollView(
      controller: controller,
      physics: physics,
      child: Table(
        columnWidths: columnWidths,
        children: bodyRows,
        border: border,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: columnWidths,
          children: [if (headerRow != null) headerRow],
          border: border,
        ),
        SizedBox(
          height: heightBody,
          child: showScrollbar
              ? Scrollbar(
                  controller: controller,
                  thumbVisibility: true,
                  child: bodyTable,
                )
              : bodyTable,
        ),
      ],
    );
  }
}
