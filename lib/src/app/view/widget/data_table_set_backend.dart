import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
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
    return DataColumn(
      label: Text(label),
      numeric: numeric,
    );
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
  final List<DTColumn<T>> columns;
  final List<Widget> Function(Widget refreshButton) actionRight;
  final List<Widget> actionLeft;
  final Status status;
  final void Function(PageOptions<T> pageOptions) onChanged;
  final PageOptions<T> pageOptions;
  final bool freezeFirstColumn;
  final bool freezeLastColumn;
  final bool pagination;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(spacing: 12, children: actionLeft),
            const Spacer(),
            Expanded(
              child: Wrap(
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.end,
                runAlignment: WrapAlignment.end,
                alignment: WrapAlignment.end,
                children: actionRight(
                  LightButtonSmall(
                    permission: null,
                    status: status,
                    action: DataAction.refresh,
                    onPressed: onRefresh,
                  ),
                )
                    .map(
                      (e) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [e],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        const Gap(12),
        Align(
          alignment: Alignment.centerRight,
          child: _buildSearchBox(),
        ),
        const Gap(24),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: ColoredBox(
                  color: theme.cardColor,
                  child: Column(
                    children: [
                      YuhuTable<T>(
                        freezeFirstColumn: freezeFirstColumn,
                        freezeLastColumn: freezeLastColumn,
                        width: columns.fold(
                          0,
                          (value, element) =>
                              (value ?? 0) + element.widthFlex * 25,
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
            onPressed: () {
              _changePage(1);
            },
            icon: const Icon(Icons.first_page),
          ),
          IconButton(
            onPressed: pageOptions.page > 1
                ? () {
                    _changePage(pageOptions.page - 1);
                  }
                : null,
            icon: const Icon(Icons.keyboard_arrow_left),
          ),
          const Gap(6),
          IconButton(
            onPressed: pageOptions.page < pageOptions.lastPage
                ? () {
                    _changePage(pageOptions.page + 1);
                  }
                : null,
            icon: const Icon(Icons.keyboard_arrow_right),
          ),
          IconButton(
            onPressed: () {
              _changePage(pageOptions.lastPage);
            },
            icon: const Icon(Icons.last_page),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return ScreenIdentifierBuilder(
      builder: (context, screenIdentifier) {
        return Visibility(
          visible: screenIdentifier.conditions(sm: false, md: true),
          child: SizedBox(
            width: 300,
            child: SearchBoxX(
              onSubmitted: _searchBoxOnChange,
              initial: pageOptions.search,
            ),
          ),
        );
      },
    );
  }

  void _searchBoxOnChange(String value) {
    onChanged(pageOptions.copyWith(search: value, data: []));
  }
}

class SearchBoxX extends StatefulWidget {
  const SearchBoxX({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.initial,
  });
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? initial;

  @override
  State<SearchBoxX> createState() => _SearchBoxXState();
}

class _SearchBoxXState extends State<SearchBoxX> {
  final _controller = TextEditingController();

  initState() {
    super.initState();
    _controller.text = widget.initial ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 45,
      padding: const EdgeInsets.only(left: 12, top: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.modeCondition(
            Colors.grey.shade300,
            Colors.grey.shade800,
          ),
        ),
        borderRadius: BorderRadius.circular(8),
        color: theme.modeCondition(Colors.white54, MyTheme.black02dp),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style:
            TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.search, size: 20),
          hintText: '${'type_here_to_search'.tr()} ...',
          hintStyle: TextStyle(
            color: theme.textTheme.bodyMedium?.color
                ?.withOpacity(theme.modeCondition(.7, .3)),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
