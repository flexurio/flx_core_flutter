import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/view/widget/table_with_body_scroll.dart';

class YuhuTableSection extends StatelessWidget {
  const YuhuTableSection({
    required this.columnWidths,
    required this.headers,
    required this.rows,
    required this.borderSide,
    required this.headerDecoration,
    this.bodyHeight,
    this.vController,
    this.showScrollbar = true,
    this.alignment = Alignment.centerLeft,
    this.decoration,
    super.key,
  });

  final Map<int, TableColumnWidth> columnWidths;
  final List<Widget> headers;
  final List<TableRow> rows;
  final BorderSide borderSide;
  final BoxDecoration headerDecoration;
  final double? bodyHeight;
  final ScrollController? vController;
  final bool showScrollbar;
  final Alignment alignment;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final table = TableWithBodyScroll(
      heightBody: bodyHeight,
      columnWidths: columnWidths,
      controller: vController,
      physics: const ClampingScrollPhysics(),
      showScrollbar: showScrollbar,
      border: TableBorder(
        verticalInside:
            borderSide.copyWith(color: borderSide.color.withAlpha(102)),
      ),
      children: <TableRow>[
        TableRow(decoration: headerDecoration, children: headers),
        ...rows,
      ],
    );

    if (decoration != null) {
      return Align(
        alignment: alignment,
        child: Container(
          decoration: decoration,
          child: table,
        ),
      );
    }

    return table;
  }
}
