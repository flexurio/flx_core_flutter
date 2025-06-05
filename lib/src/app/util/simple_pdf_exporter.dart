import 'package:flx_core_flutter/src/app/model/flavor_config.dart';
import 'package:flx_core_flutter/src/app/util/date_time_extension.dart';
import 'package:flx_core_flutter/src/app/util/group_by.dart';
import 'package:flx_core_flutter/src/app/util/pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:toastification/toastification.dart';
import 'package:printing/printing.dart';

class SimplePdfExporter<T> {
  SimplePdfExporter({
    required this.data,
    required this.title,
    required this.headers,
    required this.body,
    required this.printedBy,
    this.footerBuilder,
    this.footerGroup1Builder,
    this.footerGroup2Builder,
    this.periodStart,
    this.periodEnd,
    this.group1,
    this.group2,
  });

  final List<T> data;
  final String title;
  final List<PColumnHeader> headers;
  final List<PColumnBody<T>> body;
  final String printedBy;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  final List<PColumnFooter> Function(List<T> data)? footerBuilder;
  final List<PColumnFooter> Function(List<T> data)? footerGroup1Builder;
  final List<PColumnFooter> Function(List<T> data)? footerGroup2Builder;

  final String Function(T)? group1;
  final String Function(T)? group2;

  Future<Document> build() async {
    final pageFormat =
        body.length > 7 ? PdfPageFormat.a4.landscape : PdfPageFormat.a4;

    final header = _buildHeader(title);
    final content = _buildContent();

    final pdf = Document()
      ..addPage(
        await pdfTemplate(
          printedBy: printedBy,
          headerTitle: title,
          headerChild: header,
          pageFormat: pageFormat,
          build: (_) => content,
        ),
      );

    return pdf;
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

    if (group1 != null) {
      final grouped1 = groupBy<T>(data, group1!).entries;

      for (final g1 in grouped1) {
        content.add(
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 36 + 4, vertical: 6),
            child: Text(
              g1.key,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: PdfColor.fromInt(flavorConfig.color.intValue),
              ),
            ),
          ),
        );

        if (group2 != null) {
          final grouped2 = groupBy<T>(g1.value, group2!).entries;

          for (final g2 in grouped2) {
            content.add(
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 36 + 8, vertical: 4),
                child: Text(
                  g2.key,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: PdfColors.grey800,
                  ),
                ),
              ),
            );

            content.addAll([
              ...tableBody2<T>(
                data: g2.value,
                columns: body,
              ),
              if (footerGroup2Builder != null)
                tableFooter(
                  columns: footerGroup2Builder!(g2.value),
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                ),
            ]);
          }
        } else {
          content.addAll([
            ...tableBody2<T>(
              data: g1.value,
              columns: body,
            ),
          ]);
        }

        if (footerGroup1Builder != null) {
          content.add(
            tableFooter(
              columns: footerGroup1Builder!(g1.value),
              padding: const EdgeInsets.symmetric(horizontal: 36),
            ),
          );
        }
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
