import 'package:flx_core_flutter/src/app/model/flavor_config.dart';
import 'package:flx_core_flutter/src/app/util/date_time_extension.dart';
import 'package:flx_core_flutter/src/app/util/group_by.dart';
import 'package:flx_core_flutter/src/app/util/pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:toastification/toastification.dart';

class SimplePdfExporter<T> {
  SimplePdfExporter({
    required this.data,
    required this.title,
    required this.headers,
    required this.body,
    required this.printedBy,
    this.footerBuilder,
    this.footerGroupBuilder,
    this.periodStart,
    this.periodEnd,
    this.group,
  });

  final List<T> data;
  final String title;
  final List<PColumnHeader> headers;
  final List<PColumnBody<T>> body;
  final String printedBy;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final List<PColumnFooter> Function(List<T> data)? footerBuilder;
  final List<PColumnFooter> Function(List<T> data)? footerGroupBuilder;
  final String Function(T)? group;

  Future<Document> build() async {
    final periodStr = _formattedPeriod();
    final headerTitle = '$title$periodStr';

    final pageFormat =
        body.length > 5 ? PdfPageFormat.a4.landscape : PdfPageFormat.a4;

    final header = _buildHeader(headerTitle);
    final content = _buildContent();

    final pdf = Document()
      ..addPage(
        await pdfTemplate(
          printedBy: printedBy,
          headerTitle: headerTitle,
          headerChild: header,
          pageFormat: pageFormat,
          build: (_) => content,
        ),
      );

    return pdf;
  }

  String _formattedPeriod() {
    if (periodStart != null && periodEnd != null) {
      final start = periodStart!.ddMMyyyySlash;
      final end = periodEnd!.ddMMyyyySlash;
      return ' ($start - $end)';
    }
    return '';
  }

  Widget _buildHeader(String headerTitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [tableHeader(columns: headers)],
      ),
    );
  }

  List<Widget> _buildContent() {
    final content = <Widget>[];

    if (group != null) {
      final grouped = groupBy<T>(data, group!).entries;

      for (final groupEntry in grouped) {
        content.addAll([
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 36 + 4, vertical: 4),
            child: Text(
              groupEntry.key,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: PdfColor.fromInt(flavorConfig.color.intValue),
              ),
            ),
          ),
          ...tableBody2<T>(
            data: groupEntry.value,
            columns: body,
          ),
          if (footerGroupBuilder != null)
            tableFooter(
              columns: footerGroupBuilder!(groupEntry.value),
              padding: const EdgeInsets.symmetric(horizontal: 36),
            ),
        ]);
      }
      if (footerBuilder != null) {
        content.add(
          tableFooter(
            columns: footerBuilder!(data),
            padding: const EdgeInsets.symmetric(horizontal: 36),
          ),
        );
      }
    } else {
      content.addAll([
        ...tableBody2<T>(
          data: data,
          columns: body,
        ),
        if (footerBuilder != null)
          tableFooter(
            columns: footerBuilder!(data),
            padding: const EdgeInsets.symmetric(horizontal: 36),
          ),
      ]);
    }

    return content;
  }
}
