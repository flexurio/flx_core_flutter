import 'package:flx_core_flutter/flx_core_flutter.dart';

/*
import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:flx_core_flutter/flx_core_flutter.dart';

class SimpleExcelExporter<T> {
  // ... existing code ...
}
*/

// STUB for compilation
class SimpleExcelExporter<T> {
  SimpleExcelExporter({
    required List<T> data,
    required List<PColumnHeader> headers,
    required String title,
    required List<PColumnBody<T>> body,
    List<String>? legends,
    String? printedBy,
    String Function(T)? group1,
    String Function(T)? group2,
    List<List<PColumnFooter>> Function(List<T>)? footerBuilder,
    List<PColumnBodyN<T>> Function(List<T> data)? bodyFirstBuilder,
    List<List<PColumnFooter>> Function(List<T>)? footerGroup1Builder,
    List<List<PColumnFooter>> Function(List<T>)? footerGroup2Builder,
  });

  Iterable<int> export() sync* {
    yield* [];
  }
}
