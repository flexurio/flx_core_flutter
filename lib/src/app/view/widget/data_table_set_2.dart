import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:gap/gap.dart';
import 'package:screen_identifier/screen_identifier.dart';

class DataTableSet2<T> extends StatefulWidget {
  const DataTableSet2({
    required this.data,
    required this.title,
    required this.columns,
    required this.actionRight,
    required this.onRefresh,
    required this.status,
    this.actionLeft = const [],
    super.key,
    this.search,
    this.scrollController,
  });

  final List<T> data;
  final List<String?> Function(T)? search;
  final void Function() onRefresh;
  final String title;
  final List<DTColumnXX<T>> columns;
  final List<Widget> Function(Widget refreshButton) actionRight;
  final List<Widget> actionLeft;
  final Status status;
  final ScrollController? scrollController;

  @override
  State<DataTableSet2<T>> createState() => _DataTableSet2State();
}

class DTColumnXX<T> {
  DTColumnXX({
    required this.head,
    required this.body,
    this.text,
  });
  final DTHeadXX<T> head;

  final DataCell Function(T) body;
  final Widget? text;
}

class DTHeadXX<T> {
  const DTHeadXX({
    required this.label,
    this.sortString,
    this.sortNum,
    this.numeric = false,
  });
  final bool numeric;

  final Widget label;
  final String Function(T)? sortString;
  final num Function(T)? sortNum;

  DataColumn toDataColumn({required void Function(int, bool)? onSort}) {
    return DataColumn(
      label: label,
      onSort: onSort,
      numeric: numeric,
    );
  }
}

class DTSourceXX<T> extends DataTableSource {
  DTSourceXX({
    required this.data,
    required this.columns,
  });
  final List<T> data;
  final List<DTColumnXX<T>> columns;

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

class _DataTableSet2State<T> extends State<DataTableSet2<T>> {
  late List<T> _data;
  int? _sortColumnIndex;
  bool _sortAscending = true;
  var _modeSearch = false;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenIdentifierBuilder(
          builder: (context, screenIdentifier) {
            return _modeSearch
                ? _buildSearchBoxMobile()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(spacing: 12, children: widget.actionLeft),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Wrap(
                            spacing: 12,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: widget.actionRight(
                              LBS_JANGAN_PAKE_INI_LAGI(
                                permission: null,
                                status: widget.status,
                                action: DataAction.refresh,
                                onPressed: widget.onRefresh,
                              ),
                            ),
                          ),
                          const Gap(12),
                          _buildSearchBox(screenIdentifier),
                        ],
                      ),
                    ],
                  );
          },
        ),
        const Gap(24),
        Row(
          children: [
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  cardTheme: const CardThemeData(
                    elevation: 0,
                    color: Color.fromARGB(0, 133, 28, 28),
                  ),
                ),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                    },
                  ),
                  child: Scrollbar(
                    controller: widget.scrollController ?? _scrollController,
                    child: FCard(
                      child: PaginatedDataTable(
                        controller:
                            widget.scrollController ?? _scrollController,
                        showFirstLastButtons: true,
                        sortAscending: _sortAscending,
                        sortColumnIndex: _sortColumnIndex,
                        columns: [
                          for (final column in widget.columns)
                            column.head.toDataColumn(
                              onSort: column.head.sortString == null &&
                                      column.head.sortNum == null
                                  ? null
                                  : _sort,
                            ),
                        ],
                        source: DTSourceXX(data: _data, columns: widget.columns),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Visibility _buildSearchBox(ScreenIdentifier screenIdentifier) {
    return Visibility(
      visible: screenIdentifier.conditions(sm: false, md: true),
      child: SizedBox(
        width: 300,
        child: SearchBox(onChanged: _searchBoxOnChange),
      ),
    );
  }

  Row _buildSearchBoxMobile() {
    return Row(
      children: [
        Expanded(
          child: SearchBox(onChanged: _searchBoxOnChange),
        ),
        IconButton(
          onPressed: () => setState(() => _modeSearch = false),
          icon: const Icon(Icons.close),
          tooltip: 'Close',
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  void _searchBoxOnChange(String value) {
    _data = widget.data;
    if (_sortColumnIndex != null) {
      _sort(_sortColumnIndex!, _sortAscending);
    }
    _data = _data.where(
      (element) {
        return widget.search!(element)
            .where((element) => element != null)
            .toList()
            .map(
              (e) => e!.toLowerCase().contains(value.toLowerCase()),
            )
            .toList()
            .contains(true);
      },
    ).toList();

    setState(() {});
  }

  void _sort(
    int columnIndex,
    bool ascending,
  ) {
    _sortAscending = ascending;
    _sortColumnIndex = columnIndex;

    final sortStringFunction = widget.columns[columnIndex].head.sortString;
    final sortNumFunction = widget.columns[columnIndex].head.sortNum;

    if (sortStringFunction != null) {
      _data = sortString(widget.data, sortStringFunction, ascending);
    }

    if (sortNumFunction != null) {
      _data = sortNum(widget.data, sortNumFunction, ascending);
    }

    setState(() {});
  }
}
