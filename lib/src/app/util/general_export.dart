import 'dart:io';

import 'package:download/download.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as material;
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/util/simple_excel_exporter.dart';
import 'package:flx_core_flutter/src/app/util/simple_pdf_exporter.dart';
import 'package:gap/gap.dart';
import 'package:printing/printing.dart';

Future<void> generalExport<T>({
  required material.BuildContext context,
  required List<T> data,
  required String title,
  required List<PColumnHeader> header,
  required List<PColumnBody<T>> body,
  required String? userName,
  required Map<ExportType, String> permissions,
  String Function(T)? group,
  List<PColumnFooter> Function(List<T> data)? footer,
  List<PColumnFooter> Function(List<T> data)? footerGroup,
  DateTime? periodStart,
  DateTime? periodEnd,
}) async {
  final exportType = await showChooseExportType(context, permissions);
  if (exportType == null) return;

  var period = '';
  if (periodStart != null && periodEnd != null) {
    final start = periodStart.ddMMyyyySlash;
    final end = periodEnd.ddMMyyyySlash;
    period = ' ($start - $end)';
  }

  final fileName = '$title$period'
      .replaceAll('/', '_')
      .replaceAll(' ', '_')
      .replaceAll('-', '_');

  final printedBy = userName ?? '-';
  final titleHeader = '$title$period';

  if (exportType == ExportType.pdf) {
    final pdfExporter = SimplePdfExporter<T>(
      data: data,
      title: title,
      headers: header,
      group: group,
      body: body,
      printedBy: printedBy,
      periodStart: periodStart,
      periodEnd: periodEnd,
      footerBuilder: footer,
      footerGroupBuilder: footerGroup,
    );

    final pdf = await pdfExporter.build();
    await Printing.sharePdf(bytes: await pdf.save(), filename: '$fileName.pdf');
  } else if (exportType == ExportType.excel) {
    final excel = SimpleExcelExporter<T>(
      data: data,
      headers: header,
      title: titleHeader,
      body: body,
      printedBy: printedBy,
      group: group,
      footerBuilder: footer,
      footerGroupBuilder: footerGroup,
    );
    await download(Stream.fromIterable(excel.export()), '$fileName.xlsx');
  }
}

Future<ExportType?> showChooseExportType(
  material.BuildContext context,
  Map<ExportType, String> permissions,
) async {
  return material.showDialog<ExportType?>(
    context: context,
    builder: (context) {
      return CardForm(
        title: 'choose_export_type'.tr(),
        actions: [],
        popup: true,
        icon: material.Icons.download,
        child: material.Column(
          children: [
            ExportTypeButton(
              permissions: permissions,
              exportType: ExportType.excel,
              action: DataAction.exportExcel,
            ),
            const Gap(6),
            ExportTypeButton(
              permissions: permissions,
              exportType: ExportType.pdf,
              action: DataAction.exportPdf,
            ),
          ],
        ),
      );
    },
  );
}

class ExportTypeButton extends material.StatelessWidget {
  const ExportTypeButton({
    required this.permissions,
    required this.exportType,
    required this.action,
    super.key,
  });
  final Map<ExportType, String> permissions;
  final ExportType exportType;
  final DataAction action;

  @override
  material.Widget build(material.BuildContext context) {
    return VisibilityPermissionBuilder(
      permission: [permissions[exportType]!],
      builder: (hasPermission) {
        return material.Tooltip(
          message: !hasPermission ? 'No permission: ${action.title}' : '',
          child: material.Opacity(
            opacity: hasPermission ? 1 : .5,
            child: LBS_JANGAN_PAKE_INI_LAGI(
              action: action,
              permission: null,
              onPressed: hasPermission
                  ? () => material.Navigator.pop(context, exportType)
                  : null,
            ),
          ),
        );
      },
    );
  }
}

enum ExportType {
  pdf('PDF'),
  excel('Excel');

  const ExportType(this.name);
  final String name;
}
