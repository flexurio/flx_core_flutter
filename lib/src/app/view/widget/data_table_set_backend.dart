import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/view/widget/data_set_action.dart';
import 'package:flx_core_flutter/src/app/view/widget/data_table/widget/pagination_control.dart';
import 'package:screen_identifier/screen_identifier.dart';

class DTHead<T> {
  const DTHead({
    required this.label,
    required this.backendKeySort,
    this.backendKeySortDescending,
    this.numeric = false,
  });

  final String label;
  final String? backendKeySort;
  final String? backendKeySortDescending;
  final bool numeric;

  DataColumn toDataColumn() {
    return DataColumn(label: Text(label), numeric: numeric);
  }
}

class DTColumn<T> {
  DTColumn({
    required this.head,
    required this.body,
    required this.widthFlex,
    this.text,
  });

  final DTHead<T> head;
  final double widthFlex;
  final DataCell Function(T) body;
  final Widget? text;
}

class DTSource<T> extends DataTableSource {
  DTSource({
    required this.data,
    required this.columns,
  });

  final List<T> data;
  final List<DTColumn<T>> columns;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: [for (final column in columns) column.body(data[index])],
    );
  }
}

class DataTableBackend<T> extends StatelessWidget {
  const DataTableBackend({
    required this.pageOptions, required this.columns, required this.actionRight, required this.onRefresh, required this.status, required this.onChanged, super.key,
    this.actionLeft = const [],
    this.freezeFirstColumn = false,
    this.freezeLastColumn = false,
    this.pagination = true,
  });

  final PageOptions<T> pageOptions;
  final List<DTColumn<T>> columns;
  final List<Widget> Function(Widget refreshButton) actionRight;
  final void Function() onRefresh;
  final void Function(PageOptions<T>) onChanged;
  final Status status;
  final List<Widget> actionLeft;
  final bool freezeFirstColumn;
  final bool freezeLastColumn;
  final bool pagination;

  @override
  Widget build(BuildContext context) {
    return ScreenIdentifierBuilder(
      builder: (context, screenIdentifier) {
        final isSmall = screenIdentifier.conditions(sm: true, md: false);
        final freezeFirst = !isSmall && freezeFirstColumn;
        final freezeLast = !isSmall && freezeLastColumn;

        return DataSetAction(
          onChanged: onChanged,
          pageOptions: pageOptions,
          onRefresh: onRefresh,
          status: status,
          actionLeft: actionLeft,
          actionRight: actionRight,
          child: _buildTable(context, freezeFirst, freezeLast),
        );
      },
    );
  }

  Widget _buildTable(
    BuildContext context,
    bool freezeFirst,
    bool freezeLast,
  ) {
    final theme = Theme.of(context);
    final key = ValueKey('$freezeFirst $freezeLast');

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(
                color: theme.modeCondition(
                  Colors.blueGrey.shade100.withOpacity(.5),
                  Colors.black12,
                ),
              ),
              boxShadow: theme.modeCondition(
                [
                  const BoxShadow(
                    color: Color(0x12020617), // rgba(2,6,23,0.07)
                    offset: Offset(0, 10),
                    blurRadius: 30,
                  ),
                  const BoxShadow(
                    color: Color(0x08020617), // rgba(2,6,23,0.03)
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
                [
                  const BoxShadow(
                    color: Color(0x73000000), // ~45% black
                    offset: Offset(0, 12),
                    blurRadius: 32,
                  ),
                  const BoxShadow(
                    color: Color(0x26000000), // ~15% black
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: ColoredBox(
                color: theme.cardColor,
                child: Column(
                  children: [
                    YuhuTable<T>(
                      key: key,
                      freezeFirstColumn: freezeFirst,
                      freezeLastColumn: freezeLast,
                      width: columns.fold(
                          0, (sum, col) => (sum ?? 0) + col.widthFlex * 25,),
                      data: pageOptions.data,
                      rowsPerPage: 10,
                      initialSortColumnIndex: _getSortColumnIndex(),
                      initialSortAscending: pageOptions.ascending,
                      onSort: _onSortChanged,
                      columns: columns.map((col) {
                        return TableColumn<T>(
                          alignment: col.head.numeric
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          width: col.widthFlex * 25,
                          title: col.head.label,
                          builder: (data, _) => DefaultTextStyle(
                            style: theme.textTheme.bodyMedium!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            child: col.body(data).child,
                          ),
                        );
                      }).toList(),
                    ),
                    if (pagination) _buildPaginationControls(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _getSortColumnIndex() {
    return columns.indexWhere(
      (col) => [
        col.head.backendKeySort,
        col.head.backendKeySortDescending,
      ].contains(pageOptions.sortBy),
    );
  }

  void _onSortChanged(int index, bool ascending) {
    final column = columns[index].head;
    final sortKey = ascending
        ? column.backendKeySort
        : column.backendKeySortDescending ?? column.backendKeySort;

    onChanged(pageOptions.copyWith(
      ascending: ascending,
      sortBy: sortKey,
    ),);
  }

  void _changePage(int page) {
    onChanged(pageOptions.copyWith(page: page, data: []));
  }

  Widget _buildPaginationControls() {
    return PaginationControl<T>(
      pageOptions: pageOptions,
      changePage: _changePage,
    );
  }
}
