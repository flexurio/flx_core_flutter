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

class DataTableBackend<T> extends StatefulWidget {
  const DataTableBackend({
    required this.pageOptions,
    required this.columns,
    required this.actionRight,
    required this.onRefresh,
    required this.status,
    required this.onChanged,
    this.actionLeft = const [],
    this.freezeFirstColumn = false,
    this.freezeLastColumn = false,
    this.pagination = true,
    this.actionMultiple,
    super.key,
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

  /// Jika tidak null -> aktifkan multi-select.
  /// Saat ada terpilih, widget hasil fungsi ini akan ditampilkan di bawah tabel (di dalam kartu).
  final Widget? Function(List<T> selected)? actionMultiple;

  @override
  State<DataTableBackend<T>> createState() => _DataTableBackendState<T>();
}

class _DataTableBackendState<T> extends State<DataTableBackend<T>> {
  /// Menyimpan index baris yang terseleksi pada halaman yang sedang ditampilkan.
  final Set<int> _selectedRowIndexes = <int>{};

  @override
  Widget build(BuildContext context) {
    return ScreenIdentifierBuilder(
      builder: (context, screenIdentifier) {
        final isSmall = screenIdentifier.conditions(sm: true, md: false);
        final freezeFirst = !isSmall && widget.freezeFirstColumn;
        final freezeLast = !isSmall && widget.freezeLastColumn;

        return DataSetAction(
          onChanged: widget.onChanged,
          pageOptions: widget.pageOptions,
          onRefresh: widget.onRefresh,
          status: widget.status,
          actionLeft: widget.actionLeft,
          actionRight: widget.actionRight,
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
    final hasMulti = widget.actionMultiple != null;

    // Kondisi khusus: jika multi-select aktif dan freezeFirst true,
    // maka "bekukan kolom 1 & 2" dengan membuat kolom komposit:
    // [Checkbox] + [Kolom data pertama] digabung menjadi satu kolom paling kiri.
    final freezeTwo = hasMulti && freezeFirst;

    // Key untuk memaksa re-render saat mode freeze/multi berubah
    final key = ValueKey(
        'freezeFirst:$freezeFirst|freezeLast:$freezeLast|hasMulti:$hasMulti|freezeTwo:$freezeTwo');

    // Hitung total lebar
    final double baseWidth = widget.columns.fold<double>(
      0,
      (sum, col) => sum + (col.widthFlex * 25),
    );
    final double totalWidth = freezeTwo
        ? baseWidth // tidak menambah kolom baru; kolom 1 digabung dengan checkbox
        : (hasMulti
            ? baseWidth + 25
            : baseWidth); // tambah 25 untuk kolom checkbox terpisah

    // Siapkan daftar TableColumn<T> untuk YuhuTable
    final yuhuColumns = <TableColumn<T>>[];

    if (freezeTwo) {
      // Kolom komposit: checkbox + kolom data pertama
      final firstCol = widget.columns.first;
      final firstColWidth = firstCol.widthFlex * 25;

      yuhuColumns.add(
        TableColumn<T>(
          alignment: firstCol.head.numeric
              ? Alignment.centerRight
              : Alignment.centerLeft,
          width: 25 + firstColWidth, // gabungan lebar checkbox + kolom pertama
          title: firstCol.head.label,
          builder: (data, rowIndex) {
            final idx = rowIndex ?? 0;
            final checked = _selectedRowIndexes.contains(idx);
            return Row(
              children: [
                // Checkbox (lebar kira-kira 25 px)
                SizedBox(
                  width: 25,
                  child: Center(
                    child: Checkbox(
                      value: checked,
                      onChanged: (v) {
                        setState(() {
                          if (v == true) {
                            _selectedRowIndexes.add(idx);
                          } else {
                            _selectedRowIndexes.remove(idx);
                          }
                        });
                      },
                    ),
                  ),
                ),
                // Isi kolom pertama
                Expanded(
                  child: DefaultTextStyle(
                    style: theme.textTheme.bodyMedium!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: firstCol.body(data).child,
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Tambahkan sisa kolom mulai dari index 1
      for (int i = 1; i < widget.columns.length; i++) {
        final col = widget.columns[i];
        yuhuColumns.add(
          TableColumn<T>(
            alignment:
                col.head.numeric ? Alignment.centerRight : Alignment.centerLeft,
            width: col.widthFlex * 25,
            title: col.head.label,
            builder: (data, _) => DefaultTextStyle(
              style: theme.textTheme.bodyMedium!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: col.body(data).child,
            ),
          ),
        );
      }
    } else if (hasMulti) {
      // Kolom checkbox terpisah (bukan komposit)
      yuhuColumns.add(
        TableColumn<T>(
          alignment: Alignment.center,
          width: 25,
          title: '',
          builder: (data, rowIndex) {
            final idx = rowIndex ?? 0;
            final checked = _selectedRowIndexes.contains(idx);
            return Center(
              child: Checkbox(
                value: checked,
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      _selectedRowIndexes.add(idx);
                    } else {
                      _selectedRowIndexes.remove(idx);
                    }
                  });
                },
              ),
            );
          },
        ),
      );

      // Kolom data aslinya
      yuhuColumns.addAll(
        widget.columns.map((col) {
          return TableColumn<T>(
            alignment:
                col.head.numeric ? Alignment.centerRight : Alignment.centerLeft,
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
      );
    } else {
      // Tanpa multi-select
      yuhuColumns.addAll(
        widget.columns.map((col) {
          return TableColumn<T>(
            alignment:
                col.head.numeric ? Alignment.centerRight : Alignment.centerLeft,
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
      );
    }

    // Hitung index sort awal:
    // - freezeTwo: kolom komposit berada di index 0 dan mewakili kolom data pertama asli.
    // - hasMulti (tanpa freezeTwo): offset +1 karena kolom 0 adalah checkbox.
    // - tanpa multi: sama seperti sebelumnya.
    final originalSortIdx =
        _getSortColumnIndex(widget.pageOptions, widget.columns);
    int initialSortColumnIndex;
    if (originalSortIdx < 0) {
      initialSortColumnIndex = freezeTwo ? 0 : (hasMulti ? 1 : 0);
    } else {
      if (freezeTwo) {
        // kolom pertama asli jadi index 0; sisanya geser -1
        initialSortColumnIndex = (originalSortIdx == 0) ? 0 : originalSortIdx;
      } else if (hasMulti) {
        initialSortColumnIndex = originalSortIdx + 1;
      } else {
        initialSortColumnIndex = originalSortIdx;
      }
    }

    // Kumpulkan item terpilih (untuk actionMultiple)
    final List<T> selectedItems = _selectedRowIndexes
        .where((i) => i >= 0 && i < widget.pageOptions.data.length)
        .map((i) => widget.pageOptions.data[i])
        .toList();

    final Widget? multipleActionWidget =
        (widget.actionMultiple != null && selectedItems.isNotEmpty)
            ? widget.actionMultiple!(selectedItems)
            : null;

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
                      freezeFirstColumn:
                          freezeFirst, // tetap true -> kolom komposit dibekukan
                      freezeLastColumn: freezeLast,
                      width: totalWidth,
                      data: widget.pageOptions.data,
                      rowsPerPage: 10,
                      initialSortColumnIndex: initialSortColumnIndex,
                      initialSortAscending: widget.pageOptions.ascending,
                      onSort: (index, ascending) =>
                          _onSortChanged(index, ascending, hasMulti, freezeTwo),
                      columns: yuhuColumns,
                    ),
                    if (multipleActionWidget != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: theme.dividerColor.withOpacity(.4),
                            ),
                          ),
                        ),
                        child: multipleActionWidget,
                      ),
                    if (widget.pagination) _buildPaginationControls(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _getSortColumnIndex(PageOptions<T> page, List<DTColumn<T>> cols) {
    return cols.indexWhere(
      (col) => [
        col.head.backendKeySort,
        col.head.backendKeySortDescending,
      ].contains(page.sortBy),
    );
  }

  void _onSortChanged(
      int index, bool ascending, bool hasMulti, bool freezeTwo) {
    // Abaikan sort pada kolom checkbox murni (mode hasMulti tanpa freezeTwo)
    if (!freezeTwo && hasMulti && index == 0) return;

    // Mapping index YuhuTable -> index kolom asli
    int originalIndex;
    if (freezeTwo) {
      // index 0 = kolom komposit (kolom asli #0)
      originalIndex =
          (index == 0) ? 0 : index; // index lainnya sama dengan aslinya
    } else if (hasMulti) {
      // kolom 0 adalah checkbox, sisanya offset -1
      originalIndex = index - 1;
    } else {
      originalIndex = index;
    }

    if (originalIndex < 0 || originalIndex >= widget.columns.length) return;

    final head = widget.columns[originalIndex].head;
    final sortKey = ascending
        ? head.backendKeySort
        : (head.backendKeySortDescending ?? head.backendKeySort);

    widget.onChanged(
      widget.pageOptions.copyWith(
        ascending: ascending,
        sortBy: sortKey,
      ),
    );
  }

  void _changePage(int page) {
    // Saat pindah halaman, bersihkan pilihan
    setState(() {
      _selectedRowIndexes.clear();
    });
    widget.onChanged(widget.pageOptions.copyWith(page: page, data: []));
  }

  Widget _buildPaginationControls() {
    return PaginationControl<T>(
      pageOptions: widget.pageOptions,
      changePage: _changePage,
    );
  }
}
