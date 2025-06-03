import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as material;
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:pdf/pdf.dart' as p;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generalExport<T>({
  required material.BuildContext context,
  required List<T> data,
  required String title,
  required List<PColumnHeader> header,
  required List<PColumnBody<T>> body,
  required List<PColumnFooter> Function(List<T> data) footer,
  required String? userName,
  DateTime? periodStart,
  DateTime? periodEnd,
}) async {
  print('[generalExport] title: $title, length: ${data.length}');

  final exportType = await showChooseExportType(context);
  if (exportType == null) return;

  print('[generalExport] exportType: $exportType');
  var period = '';
  if (periodStart != null && periodEnd != null) {
    final start = periodStart.ddMMyyyySlash;
    final end = periodEnd.ddMMyyyySlash;
    period = ' ($start - $end)';
  }

  if (exportType == ExportType.pdf) {
    final pages = await pdfTemplate(
      printedBy: userName ?? '-',
      headerTitle: '$title$period',
      headerChild: pw.Padding(
        padding: const pw.EdgeInsets.only(left: 36, right: 36),
        child: pw.Column(children: [tableHeader(columns: header)]),
      ),
      pageFormat:
          body.length > 5 ? p.PdfPageFormat.a4.landscape : p.PdfPageFormat.a4,
      build: (context) => [
        ...tableBody2<T>(
          data: data,
          columns: body,
        ),
        tableFooter(
            columns: footer(data),
            padding: const pw.EdgeInsets.symmetric(horizontal: 36)),
      ],
    );
    final pdf = pw.Document()..addPage(pages);
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Material Status Rupiah Quarantine.pdf',
    );
  } else if (exportType == ExportType.excel) {
    // simpleExcel<T>(context: null, data: data(), title: title);
  }
}

Future<ExportType?> showChooseExportType(material.BuildContext context) async {
  return material.showDialog<ExportType?>(
      context: context,
      builder: (context) {
        return CardForm(
          title: 'choose_export_type'.tr(),
          actions: [],
          popup: true,
          icon: material.Icons.download,
          child: material.Column(
            children: ExportType.values.map((e) {
              return Button.string(
                permission: null,
                action: 'Export ${e.name}',
                isInProgress: false,
                onPressed: () {
                  material.Navigator.pop(context, e);
                },
              );
            }).toList(),
          ),
        );
      });
}

enum ExportType {
  pdf('PDF'),
  excel('Excel');

  const ExportType(this.name);
  final String name;
}
