import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TableHeader extends StatelessWidget {
  const TableHeader(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TableData extends StatelessWidget {
  const TableData({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}

class TableColumnX<T> {
  TableColumnX({
    required this.title,
    required this.builder,
    this.alignment = Alignment.centerLeft,
    this.width,
    this.tooltip,
  });

  final String title;
  final Alignment alignment;
  final double? width;
  final String? tooltip;
  final Widget Function(T, int) builder;
}

class SimpleTable<T> extends StatelessWidget {
  const SimpleTable({
    required this.data,
    required this.columns,
    this.width,
    super.key,
    this.rowHeight = 48,
    this.status = Status.loaded,
  });
  final double rowHeight;
  final Status status;
  final List<T> data;
  final double? width;

  final List<TableColumnX<T>> columns;

  @override
  Widget build(BuildContext context) {
    final columnWidths = <int, TableColumnWidth>{};
    for (var i = 0; i < columns.length; i++) {
      final width = columns[i].width;
      if (width != null) {
        columnWidths[i] = FixedColumnWidth(width);
      }
    }

    Widget table = Table(
      columnWidths: columnWidths,
      children: [
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          children: List.generate(
            columns.length,
            (index) => _TableHeader(columns[index]),
          ),
        ),
        ...List.generate(
          data.length,
          (row) {
            return TableRow(
              children: List.generate(
                columns.length,
                (column) => _TableData(
                  height: rowHeight,
                  alignment: columns[column].alignment,
                  child: columns[column].builder(data[row], row),
                ),
              ),
            );
          },
        ),
      ],
    );

    if (width != null) {
      final scrollController = ScrollController();
      table = Row(
        children: [
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              interactive: true,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: width,
                  child: table,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        table,
        if (status == Status.progress)
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: CupertinoActivityIndicator(),
          ),
        if (status == Status.error)
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Icon(Icons.error, color: Colors.red),
          ),
      ],
    );
  }
}

class _TableHeader<T> extends StatelessWidget {
  const _TableHeader(this.column);

  final TableColumnX<T> column;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    Widget? child;
    if (column.tooltip != null) {
      child = Tooltip(
        message: column.tooltip,
        child: Row(
          children: [
            Text(
              column.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Gap(6),
            const Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.blueGrey,
            ),
          ],
        ),
      );
    } else {
      child = Text(
        column.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    }
    return Container(
      color: primaryColor.withOpacity(.09),
      padding: const EdgeInsets.all(12),
      child: Align(
        alignment: column.alignment,
        child: child,
      ),
    );
  }
}

class _TableData extends StatelessWidget {
  const _TableData({
    required this.child,
    required this.height,
    required this.alignment,
  });

  final Widget child;
  final double height;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
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

class TableWithBodyScroll extends StatelessWidget {
  final Map<int, TableColumnWidth>? columnWidths;
  final List<TableRow> children;
  final double? heightBody;
  final TableBorder? border;  // Add the border parameter

  const TableWithBodyScroll({
    Key? key,
    this.columnWidths,
    required this.children,
    this.heightBody,
    this.border,  // Add border in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (heightBody == null) {
      return Table(
        columnWidths: columnWidths,
        children: children,
        border: border,  // Apply the border to the table
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
            border: border,  // Apply the border to the header table
          ),
        SizedBox(
          height: heightBody,
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Table(
                columnWidths: columnWidths,
                children: bodyRows,
                border: border,  // Apply the border to the body table
              ),
            ),
          ),
        ),
      ],
    );
  }
}