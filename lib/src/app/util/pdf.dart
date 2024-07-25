import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> getCompanyLogoPdf() async {
  final logo = await rootBundle
      .load('asset/image/logo-company-${flavorConfig.companyId}.png');
  return logo.buffer.asUint8List();
}

Padding headerPdf({
  required Font font,
  required Uint8List companyLogo,
  required String title,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  font: font,
                ),
              ),
              SizedBox(height: 6),
              Text(flavorConfig.companyName),
            ],
          ),
        ),
        Image(MemoryImage(companyLogo), width: 40, height: 40),
      ],
    ),
  );
}

Container footerPdf({required String printedBy}) {
  final now = DateTime.now();
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        top: BorderSide(),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Row(
        children: [
          Text(
            'Printed: ${now.yMMMdHm} GMT${now.timeZoneOffset.inHours}',
            style: const TextStyle(fontSize: 10),
          ),
          SizedBox(width: 24),
          Text(
            'Printed by: $printedBy',
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    ),
  );
}

class PColumn<T> {
  PColumn({
    required this.title,
    required this.builder,
    this.numeric = false,
  });

  final String title;
  final bool numeric;
  final String Function(T data, int index) builder;
}

Table simpleTablePdf<T>({
  required List<T> data,
  required List<PColumn<T>> columns,
}) {
  const paddingRow = EdgeInsets.symmetric(vertical: 6, horizontal: 6);
  return Table(
    border: TableBorder.all(color: PdfColors.grey300),
    columnWidths: {
      for (var i = 0; i < columns.length; i++) i: const FlexColumnWidth(2),
    },
    children: [
      TableRow(
        children: [
          for (final column in columns)
            Container(
              padding: paddingRow,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(),
                  bottom: BorderSide(),
                ),
              ),
              child: Text(
                column.title,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: PdfColors.grey900,
                ),
              ),
            ),
        ],
      ),
      ...List<TableRow>.generate(
        data.length,
        (index) => TableRow(
          children: [
            for (final column in columns)
              Container(
                padding: paddingRow,
                alignment: column.numeric ? Alignment.centerRight : null,
                child: Text(
                  column.builder(data[index], index),
                  style: const TextStyle(fontSize: 8),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}
