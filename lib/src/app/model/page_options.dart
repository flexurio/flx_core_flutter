import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class PageOptions<T> {
  PageOptions({
    required this.page,
    required this.search,
    required this.sortBy,
    required this.totalRows,
    required this.data,
    this.ascending = true,
    this.rowsPerPage = 10,
  });

  factory PageOptions.empty({
    bool? ascending,
    String? sortBy,
    List<T>? data,
    String search = '',
    int rowsPerPage = 10,
  }) {
    return PageOptions<T>(
      page: 1,
      search: search,
      sortBy: sortBy ?? 'created_at',
      rowsPerPage: rowsPerPage,
      totalRows: rowsPerPage,
      ascending: ascending ?? false,
      data: data ?? [],
    );
  }

  factory PageOptions.emptyNoLimit({
    bool? ascending,
    String? sortBy,
    String? search,
  }) {
    return PageOptions<T>(
      page: 1,
      search: search ?? '',
      sortBy: sortBy ?? 'created_at',
      totalRows: 0,
      ascending: ascending ?? false,
      rowsPerPage: 90000,
      data: [],
    );
  }

  PageOptions<T> setFromApi(
    Response<Map<String, dynamic>> response,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final productReceiveDetails = <T>[];
    final data = response.data!['data'] as List;

    for (final data in data) {
      productReceiveDetails.add(fromJson(data as Map<String, dynamic>));
    }
    var totalData = 0;
    if (response.data!.containsKey('total_data')) {
      totalData = response.data!['total_data'] as int;
    }
    return copyWith(
      data: productReceiveDetails,
      totalRows: totalData,
    );
  }

  final int page;
  final String search;
  final String sortBy;
  final bool ascending;
  final int rowsPerPage;
  final int totalRows;
  final List<T> data;

  int get lastPage => (totalRows / rowsPerPage).ceil();

  bool get hasMore => data.length >= rowsPerPage;

  String get info {
    var rowStart = 0;
    var rowEnd = 0;
    if (totalRows > 0) {
      final offset = (page - 1) * rowsPerPage;
      rowStart = offset + 1;

      rowEnd = offset + rowsPerPage;
      if (rowEnd > totalRows) {
        rowEnd = totalRows;
      }
    }
    return 'pagination_info'.tr(
      namedArgs: {
        'start_row': rowStart.toString(),
        'end_row': rowEnd.toString(),
        'total_rows': totalRows.toString(),
      },
    );
  }

  Map<String, dynamic> toUrlQueryMap() {
    bool? ascendingParam = ascending;
    if (sortBy.toLowerCase().contains(' asc') ||
        sortBy.toLowerCase().contains(' desc')) {
      ascendingParam = null;
    }

    return {
      'page': page,
      'search': search,
      'sort': sortBy,
      'ascending': ascendingParam,
      'limit': rowsPerPage,
    };
  }

  PageOptions<T> copyWith({
    int? page,
    String? search,
    String? sortBy,
    bool? ascending,
    int? rowsPerPage,
    int? totalRows,
    List<T>? data,
  }) {
    return PageOptions<T>(
      page: page ?? this.page,
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      totalRows: totalRows ?? this.totalRows,
      data: data ?? this.data,
    );
  }
}
