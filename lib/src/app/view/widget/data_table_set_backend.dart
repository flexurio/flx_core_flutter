import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flexurio_erp_core/src/app/view/widget/data_set_action.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:screen_identifier/screen_identifier.dart';

class DTHead<T> {
  const DTHead({
    required this.label,
    required this.backendColumn,
    this.numeric = false,
  });
  final bool numeric;
  final String label;
  final String? backendColumn;

  DataColumn toDataColumn() {
    return DataColumn(label: Text(label), numeric: numeric);
  }
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

class DataTableBackend<T> extends StatelessWidget {
  const DataTableBackend({
    required this.pageOptions,
    required this.columns,
    required this.actionRight,
    required this.onRefresh,
    required this.status,
    required this.onChanged,
    this.actionLeft = const [],
    super.key,
    this.freezeFirstColumn = false,
    this.freezeLastColumn = false,
    this.pagination = true,
  });

  final void Function() onRefresh;
  final List<Widget> Function(Widget refreshButton) actionRight;
  final void Function(PageOptions<T> pageOptions) onChanged;
  final PageOptions<T> pageOptions;
  final List<Widget> actionLeft;
  final List<DTColumn<T>> columns;
  final Status status;
  final bool freezeFirstColumn;
  final bool freezeLastColumn;
  final bool pagination;

  @override
  Widget build(BuildContext context) {
    var freezeFirstColumnLocal = freezeFirstColumn;
    var freezeLastColumnLocal = freezeLastColumn;
    return ScreenIdentifierBuilder(
      builder: (context, screenIdentifier) {
        final isSmall = screenIdentifier.conditions(sm: true, md: false);
        if (isSmall) {
          freezeFirstColumnLocal = false;
          freezeLastColumnLocal = false;
        }
        return DataSetAction(
          onChanged: onChanged,
          pageOptions: pageOptions,
          actionLeft: actionLeft,
          actionRight: actionRight,
          onRefresh: onRefresh,
          status: status,
          child: _buildTable(
            context: context,
            freezeLastColumnLocal: freezeLastColumnLocal,
            freezeFirstColumnLocal: freezeFirstColumnLocal,
          ),
        );
      },
    );
  }

  Widget _buildTable({
    required BuildContext context,
    required bool freezeLastColumnLocal,
    required bool freezeFirstColumnLocal,
  }) {
    final key = ValueKey('$freezeFirstColumnLocal $freezeLastColumnLocal');
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: ColoredBox(
              color: theme.cardColor,
              child: Column(
                children: [
                  YuhuTable<T>(
                    key: key,
                    freezeFirstColumn: freezeFirstColumnLocal,
                    freezeLastColumn: freezeLastColumnLocal,
                    width: columns.fold(
                      0,
                      (value, element) => (value ?? 0) + element.widthFlex * 25,
                    ),
                    data: pageOptions.data,
                    rowsPerPage: 10,
                    initialSortColumnIndex: columns.indexWhere(
                      (e) => e.head.backendColumn == pageOptions.sortBy,
                    ),
                    initialSortAscending: pageOptions.ascending,
                    onSort: (index, ascending) {
                      onChanged(
                        pageOptions.copyWith(
                          ascending: ascending,
                          sortBy: columns[index].head.backendColumn,
                        ),
                      );
                    },
                    columns: [
                      for (final column in columns)
                        TableColumn<T>(
                          alignment: column.head.numeric
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          width: column.widthFlex * 25,
                          title: column.head.label,
                          builder: (data, _) {
                            return DefaultTextStyle(
                              style: theme.textTheme.bodyMedium!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: column.body(data).child,
                            );
                          },
                        ),
                    ],
                  ),
                  if (pagination) _buildPaginationNumber(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _changePage(int page) {
    onChanged(pageOptions.copyWith(page: page, data: []));
  }

  Padding _buildPaginationNumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(pageOptions.info),
          const Gap(12),
          IconButton(
            onPressed: () => _changePage(1),
            icon: const Icon(Icons.first_page),
          ),
          IconButton(
            onPressed: pageOptions.page > 1
                ? () => _changePage(pageOptions.page - 1)
                : null,
            icon: const Icon(Icons.keyboard_arrow_left),
          ),
          const Gap(6),
          IconButton(
            onPressed: pageOptions.page < pageOptions.lastPage
                ? () => _changePage(pageOptions.page + 1)
                : null,
            icon: const Icon(Icons.keyboard_arrow_right),
          ),
          IconButton(
            onPressed: () => _changePage(pageOptions.lastPage),
            icon: const Icon(Icons.last_page),
          ),
        ],
      ),
    );
  }
}
