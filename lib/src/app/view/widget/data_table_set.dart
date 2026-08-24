import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:gap/gap.dart';
import 'package:screen_identifier/screen_identifier.dart';

class DataTableSetJanganDipakaiLagi<T> extends StatefulWidget {
  @Deprecated('use `DataTableSet2(...)` ')
  const DataTableSetJanganDipakaiLagi({
    required this.data,
    required this.title,
    required this.columns,
    required this.actionRight,
    required this.isProgress,
    required this.onRefresh,
    required this.isError,
    this.actionLeft = const [],
    super.key,
    this.search,
    this.scrollController,
  });

  final List<T> data;
  final List<String?> Function(T)? search;
  final void Function() onRefresh;
  final String title;
  final List<DTColumnX<T>> columns;
  final List<Widget> actionRight;
  final List<Widget> actionLeft;
  final bool isProgress;
  final bool isError;
  final ScrollController? scrollController;

  @override
  State<DataTableSetJanganDipakaiLagi<T>> createState() =>
      _DataTableSetJanganDipakaiLagiState();
}

class DTColumnX<T> {
  DTColumnX({
    required this.head,
    required this.body,
    this.text,
  });
  final DTHeadX<T> head;

  final DataCell Function(T) body;
  final Widget? text;
}

class DTHeadX<T> {
  const DTHeadX({
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
      label: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return DefaultTextStyle(
            style: theme.textTheme.bodyMedium!,
            child: label,
          );
        },
      ),
      onSort: onSort,
      numeric: numeric,
    );
  }
}

class DTSourceX<T> extends DataTableSource {
  DTSourceX({
    required this.data,
    required this.columns,
  });
  final List<T> data;
  final List<DTColumnX<T>> columns;

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

class _DataTableSetJanganDipakaiLagiState<T>
    extends State<DataTableSetJanganDipakaiLagi<T>> {
  late List<T> _data;
  int? _sortColumnIndex;
  bool _sortAscending = true;
  var _modeSearch = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _buildTitle(),
        const Gap(24),
        ScreenIdentifierBuilder(
          builder: (context, screenIdentifier) {
            return _modeSearch
                ? _buildSearchBoxMobile()
                : Row(
                    children: [
                      Visibility(
                        visible: screenIdentifier.conditions(
                          sm: true,
                          md: false,
                        ),
                        child: IconButton(
                          onPressed: () => setState(() => _modeSearch = true),
                          icon: const Icon(Icons.search),
                          tooltip: 'search'.tr(),
                        ),
                      ),
                      Wrap(spacing: 12, children: widget.actionLeft),
                      const Spacer(),
                      if (widget.search != null)
                        _buildSearchBox(screenIdentifier),
                      const Gap(12),
                      Wrap(spacing: 12, children: widget.actionRight),
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
                    controller: widget.scrollController,
                    child: PaginatedDataTable(
                      headingRowColor: WidgetStatePropertyAll<Color>(
                        theme.modeCondition(
                          Colors.grey.shade100,
                          MyTheme.black24dp,
                        ),
                      ),
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
                      source: DTSourceX(data: _data, columns: widget.columns),
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
        width: 250,
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

  Widget _buildTitle() {
    return Row(
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const Gap(12),
        SizedBox(
          width: 30,
          height: 30,
          child: Center(
            child: widget.isProgress
                ? const CupertinoActivityIndicator()
                : IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: widget.onRefresh,
                    icon: const Icon(Icons.sync),
                    tooltip: 'refresh'.tr(),
                  ),
          ),
        ),
        const Gap(12),
        Visibility(
          visible: widget.isError,
          child: const Tooltip(
            message: errorSomethingWentWrong,
            child: Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
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
