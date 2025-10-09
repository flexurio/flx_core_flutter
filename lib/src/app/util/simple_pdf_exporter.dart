import 'package:flx_core_flutter/src/app/model/flavor_config.dart';
import 'package:flx_core_flutter/src/app/util/group_by.dart';
import 'package:flx_core_flutter/src/app/util/pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:toastification/toastification.dart';

class Signature {
  Signature({required this.name, required this.position, this.date});

  final String name;
  final String position;
  final String? date;
}

class SimplePdfExporter<T> {
  SimplePdfExporter({
    required this.data,
    required this.title,
    required this.headers,
    required this.body,
    required this.printedBy,
    this.bodyFirstBuilder,
    this.footerBuilder,
    this.footerGroup1Builder,
    this.footerGroup2Builder,
    this.periodStart,
    this.periodEnd,
    this.group1,
    this.group2,
    this.footNote,
    this.qrCode,
    this.legends,
    this.pageFormat,
    this.signatures = const [],
  });

  final List<Signature> signatures;
  final List<T> data;
  final String title;
  final List<PColumnHeader> headers;
  final List<PColumnBodyN<T>> Function(List<T> data)? bodyFirstBuilder;
  final List<PColumnBody<T>> body;
  final String printedBy;
  final String? footNote;
  final String? qrCode;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final PdfPageFormat? pageFormat;

  final List<List<PColumnFooter>> Function(List<T> data)? footerBuilder;
  final List<List<PColumnFooter>> Function(List<T> data)? footerGroup1Builder;
  final List<List<PColumnFooter>> Function(List<T> data)? footerGroup2Builder;

  final String Function(T)? group1;
  final String Function(T)? group2;

  final List<String>? legends;

  Future<Document> build() async {
    final p = pageFormat ??
        (body.length > 7 ? PdfPageFormat.a4.landscape : PdfPageFormat.a4);

    final header = _buildHeader(title);
    final content = _buildContent();

    final pdf = Document()
      ..addPage(
        await pdfTemplate(
          printedBy: printedBy,
          headerTitle: title,
          headerChild: header,
          qrCode: qrCode,
          pageFormat: p,
          build: (_) => content,
          footerNote: footNote,
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
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
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
                    const EdgeInsets.symmetric(horizontal: 44, vertical: 4),
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

            if (bodyFirstBuilder != null) {
              final body = bodyFirstBuilder!(g2.value);
              final columns = body.map((e) {
                return PColumnBody(
                  contentBuilder: (_, __) => e.content,
                  flex: e.flex,
                  numeric: e.numeric,
                );
              }).toList();
              content.addAll(
                tableBody2(
                  data: [1],
                  columns: columns,
                ),
              );
            }

            content.addAll([
              ...tableBody2<T>(data: g2.value, columns: body),
              if (footerGroup2Builder != null)
                ..._buildFooters(footerGroup2Builder!(g2.value)),
            ]);
          }
        } else {
          if (bodyFirstBuilder != null) {
            final body = bodyFirstBuilder!(g1.value);
            final columns = body.map((e) {
              return PColumnBody(
                contentBuilder: (_, __) => e.content,
                flex: e.flex,
                numeric: e.numeric,
              );
            }).toList();
            content.addAll(
              tableBody2(
                data: [1],
                columns: columns,
              ),
            );
          }

          content.addAll([
            ...tableBody2<T>(data: g1.value, columns: body),
          ]);
        }

        if (footerGroup1Builder != null) {
          content.addAll(_buildFooters(footerGroup1Builder!(g1.value)));
        }
      }

      if (footerBuilder != null) {
        content.addAll(_buildFooters(footerBuilder!(data)));
      }
    } else {
      if (bodyFirstBuilder != null) {
        final body = bodyFirstBuilder!(data);
        final columns = body.map((e) {
          return PColumnBody(
            contentBuilder: (_, __) => e.content,
            flex: e.flex,
            numeric: e.numeric,
          );
        }).toList();
        content.addAll(
          tableBody2(
            data: [1],
            columns: columns,
          ),
        );
      }
      content.addAll([
        ...tableBody2<T>(data: data, columns: body),
        if (footerBuilder != null) ..._buildFooters(footerBuilder!(data)),
      ]);
    }

    if (legends != null && legends!.isNotEmpty) {
      content.add(SizedBox(height: 16));

      for (final legend in legends!) {
        content.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 2),
            child: Text(
              legend,
              style: const TextStyle(
                fontSize: 9,
                color: PdfColors.black,
              ),
            ),
          ),
        );
      }
    }

    // --- Signatures section ---
    if (signatures.isNotEmpty) {
      content.addAll(_buildSignatures());
    }

    return content;
  }

  List<Widget> _buildFooters(List<List<PColumnFooter>> groupedFooters) {
    return groupedFooters
        .map(
          (row) => tableFooter(
            columns: row,
            padding: const EdgeInsets.symmetric(horizontal: 36),
          ),
        )
        .toList();
  }

  // ===== Signatures implementation =====

  List<Widget> _buildSignatures() {
    return [
      SizedBox(height: 32),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: signatures
              .map(
                _signatureBox,
              )
              .toList(),
        ),
      ),
    ];
  }

  Widget _signatureBox(Signature s) {
    // Fixed width box, centered content
    return Container(
      width: 140, // fixed width
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (s.date != null && s.date!.trim().isNotEmpty) ...[
            Text(
              s.date!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 8,
                color: PdfColors.grey700,
              ),
            ),
            SizedBox(height: 4),
          ],
          SizedBox(height: 60), // space for handwritten signature
          Container(height: 0.5, color: PdfColors.grey600),
          SizedBox(height: 4),
          Text(
            s.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            s.position,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              color: PdfColors.grey700,
            ),
          ),
        ],
      ),
    );
  }
}
