import 'package:flexurio_erp_core/src/app/util/pdf.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

const paddingRow = EdgeInsets.symmetric(vertical: 6, horizontal: 6);

Future<Page> pdfGeneral({
  required List<Map<String, dynamic>> data,
  required String title,
  required List<String> fields,
  required String printedBy,
}) async {
  // Validate fields
  for (final field in fields) {
    if (!data[0].containsKey(field)) {
      throw Exception(
          'The specified field "$field" is missing from the data. Available '
              'fields are: ${data[0].keys.join(', ')}.',);
    }
  }

  final keys = fields;

  final header = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 36),
    child: tableHeader(
      columns: keys
          .map(
              (e) => PColumnHeader(title: e.replaceAll('_', ' ').toUpperCase()),)
          .toList(),
    ),
  );

  final body = data.map((data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: tableBody<Map<String, dynamic>>(
        data: [data],
        columns: keys.map(
          (e) {
            var value = data[e];
            final isNum = value is num;
            if (value is String) {
              final regex = RegExp(
                  r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(\.\d+)?Z$',);
              if (regex.hasMatch(value)) {
                try {
                  value = DateFormat.LLLL(DateTime.parse(value));
                } catch (e) {
                  value = 'Invalid date';
                }
              }
            }
            return PColumnBody<Map<String, dynamic>>(
              numeric: isNum,
              contentBuilder: (data, index) =>
                  isNum ? value.toString() : ((value as String?) ?? ''),
            );
          },
        ).toList(),
      ),
    );
  });

  return pdfTemplate(
    printedBy: printedBy,
    pageFormat: PdfPageFormat.a3.landscape,
    headerTitle: title,
    headerChild: header,
    build: (context) => body.toList(),
  );
}
