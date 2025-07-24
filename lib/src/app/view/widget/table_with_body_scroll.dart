import 'package:flutter/material.dart';

class TableWithBodyScroll extends StatelessWidget {
  // Add the border parameter

  const TableWithBodyScroll({
    required this.children,
    super.key,
    this.columnWidths,
    this.heightBody,
    this.border, // Add border in constructor
  });
  final Map<int, TableColumnWidth>? columnWidths;
  final List<TableRow> children;
  final double? heightBody;
  final TableBorder? border;

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

    return Column(
      children: [
        if (headerRow != null)
          Table(
            columnWidths: columnWidths,
            children: [headerRow],
            border: border, // Apply the border to the header table
          ),
        SizedBox(
          height: heightBody,
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Table(
                columnWidths: columnWidths,
                children: bodyRows,
                border: border, // Apply the border to the body table
              ),
            ),
          ),
        ),
      ],
    );
  }
}
