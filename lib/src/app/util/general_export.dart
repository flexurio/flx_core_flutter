import 'package:download/download.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as material;
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/util/simple_excel_exporter.dart';
import 'package:flx_core_flutter/src/app/util/simple_pdf_exporter.dart';
import 'package:gap/gap.dart';
import 'package:printing/printing.dart';

class GeneralExporter<T> {
  GeneralExporter({
    required this.context,
    required this.data,
    required this.title,
    required this.headers,
    required this.body,
    required this.permissions,
    this.bodyFirstBuilder,
    this.userName,
    this.group1,
    this.group2,
    this.footerBuilder,
    this.footerGroup1Builder,
    this.footerGroup2Builder,
    this.periodStart,
    this.periodEnd,
    this.footNote,
  });

  final material.BuildContext context;
  final List<T> data;
  final String title;
  final String? footNote;
  final List<PColumnHeader> headers;
  final List<PColumnBody<T>> body;
  final Map<ExportType, String> permissions;

  final String? userName;
  final String Function(T)? group1;
  final String Function(T)? group2;

  final List<PColumnBodyN<T>> Function(List<T> data)? bodyFirstBuilder;

  final List<List<PColumnFooter>> Function(List<T>)? footerBuilder;
  final List<List<PColumnFooter>> Function(List<T>)? footerGroup1Builder;
  final List<List<PColumnFooter>> Function(List<T>)? footerGroup2Builder;

  final DateTime? periodStart;
  final DateTime? periodEnd;

  Future<void> export() async {
    print('[export] length: ${data.length}');

    final response = await showChooseExportType(
      hasGroup: group1 != null || group2 != null,
    );
    if (response == null) return;

    final exportType = response.$1;
    final isWithoutGrouping = response.$2;

    switch (exportType) {
      case ExportType.pdf:
        await exportPdf();
      case ExportType.excel:
        await exportExcel(isWithoutGrouping: isWithoutGrouping);
    }
  }

  Future<(ExportType, bool)?> showChooseExportType(
      {required bool hasGroup}) async {
    return material.showDialog<(ExportType, bool)?>(
      context: context,
      builder: (context) {
        return CardForm(
          title: 'choose_export_type'.tr(),
          actions: [],
          popup: true,
          icon: material.Icons.download,
          child: material.Column(
            children: [
              const Gap(24),
              ExportTypeButton(
                permissions: permissions,
                exportType: ExportType.excel,
                action: DataAction.exportExcel,
              ),
              const Gap(6),
              if (hasGroup) ...[
                ExportTypeButton(
                  permissions: permissions,
                  exportType: ExportType.excel,
                  action: DataAction.exportExcelWithoutGrouping,
                ),
                const Gap(6),
              ],
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

  Future<void> exportPdf() async {
    final pdfExporter = SimplePdfExporter<T>(
      data: data,
      title: '$title$period',
      headers: headers,
      body: body,
      printedBy: userName ?? '-',
      group1: group1,
      group2: group2,
      footerBuilder: footerBuilder,
      bodyFirstBuilder: bodyFirstBuilder,
      footerGroup1Builder: footerGroup1Builder,
      footerGroup2Builder: footerGroup2Builder,
      periodStart: periodStart,
      periodEnd: periodEnd,
      footNote: footNote,
    );

    final pdf = await pdfExporter.build();
    await Printing.sharePdf(bytes: await pdf.save(), filename: '$fileName.pdf');
  }

  String get period {
    var period = '';
    if (periodStart != null && periodEnd != null) {
      final start = periodStart!.ddMMyyyySlash;
      final end = periodEnd!.ddMMyyyySlash;
      period = ' ($start - $end)';
    }
    return period;
  }

  String get fileName {
    return '$title$period'
        .replaceAll(RegExp('[^a-zA-Z0-9]'), '_')
        .replaceAll(RegExp('_+'), '_');
  }

  Future<void> exportExcel({bool isWithoutGrouping = false}) async {
    var group1 = this.group1;
    var group2 = this.group2;
    final headers = this.headers;
    final body = this.body;
    var footerBuilder = this.footerBuilder;
    var footerGroup1Builder = this.footerGroup1Builder;
    var footerGroup2Builder = this.footerGroup2Builder;
    var title = '${this.title}$period';
    var fileName = this.fileName;
    var bodyFirstBuilder = this.bodyFirstBuilder;

    if (isWithoutGrouping) {
      title += ' Without Grouping';
      fileName += ' Without Grouping';

      if (this.group2 != null) {
        headers.insert(
          0,
          PColumnHeader(title: 'Group 2'),
        );
        body.insert(
          0,
          PColumnBody<T>(
            contentBuilder: (d, i) => this.group2!(d),
          ),
        );
      }

      if (this.group1 != null) {
        headers.insert(
          0,
          PColumnHeader(title: 'Group 1'),
        );
        body.insert(
          0,
          PColumnBody<T>(
            contentBuilder: (d, i) => this.group1!(d),
          ),
        );
      }

      group1 = null;
      group2 = null;
      footerBuilder = null;
      footerGroup1Builder = null;
      footerGroup2Builder = null;
      bodyFirstBuilder = null;
    }

    final excel = SimpleExcelExporter<T>(
      data: data,
      headers: headers,
      title: title,
      body: body,
      printedBy: userName ?? '-',
      group1: group1,
      group2: group2,
      footerBuilder: footerBuilder,
      bodyFirstBuilder: bodyFirstBuilder,
      footerGroup1Builder: footerGroup1Builder,
      footerGroup2Builder: footerGroup2Builder,
    );
    await download(Stream.fromIterable(excel.export()), '$fileName.xlsx');
    print('[export] excel done');
  }
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
            child: LightButtonSmall(
              action: action,
              permissions: null,
              onPressed: hasPermission
                  ? () {
                      final isWithoutGrouping =
                          action == DataAction.exportExcelWithoutGrouping;
                      material.Navigator.pop(
                        context,
                        (exportType, isWithoutGrouping),
                      );
                    }
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

extension ExportTypeExtension on Map<ExportType, String> {
  List<String> get toList => values.toList();
}
