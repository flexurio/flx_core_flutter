import 'package:flutter/services.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

Future<(Uint8List logo, Uint8List logoNamed)> getCompanyLogoPdf() async {
  final logo = await rootBundle
      .load('asset/image/logo-company-${flavorConfig.companyId}.png');
  final logoNamed = await rootBundle
      .load('asset/image/logo-name-company-${flavorConfig.companyId}.png');
  return (logo.buffer.asUint8List(), logoNamed.buffer.asUint8List());
}

Widget footerPdf({
  required Context context,
  required String printedBy,
  String? footNote,
  double paddingHorizontal = 36,
}) {
  final now = DateTime.now();
  final primaryColor = PdfColor.fromInt(flavorConfig.color.value);
  return Stack(
    children: [
      Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: paddingHorizontal,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Authorized Access:',
                        style: TextStyle(
                          fontSize: 9,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Only authorized personnel who have been specifically granted permission and have completed the necessary confidentiality training are allowed to print, handle, or view confidential documents.',
                        style: const TextStyle(
                          fontSize: 7,
                          color: PdfColors.blueGrey700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: PdfColors.grey50,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: paddingHorizontal,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Printed by: $printedBy',
                        style: const TextStyle(
                          fontSize: 7,
                          color: PdfColors.blueGrey800,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Printed on: ${now.yMMMdHm} GMT+${now.timeZoneOffset.inHours}',
                        style: const TextStyle(
                          fontSize: 7,
                          color: PdfColors.blueGrey800,
                        ),
                      ),
                    ],
                  ),
                  if (footNote != null)
                    Text(
                      footNote,
                      style: const TextStyle(
                        fontSize: 7,
                        color: PdfColors.blueGrey800,
                      ),
                    ),
                  Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: const TextStyle(
                      fontSize: 7,
                      color: PdfColors.blueGrey800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          height: 150,
          width: 4,
          color: PdfColor.fromInt(flavorConfig.color.lighten(.45).value),
        ),
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          height: 38,
          width: 4,
          color: PdfColor.fromInt(flavorConfig.color.lighten(.3).value),
        ),
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Container(width: 200, height: 1.5, color: primaryColor),
      ),
    ],
  );
}

class PGroup<T> {
  PGroup({
    required this.children,
    this.title,
    this.numeric = false,
    this.primary = false,
    this.footer,
  });

  final List<PColumn<T>> children;
  final String? title;
  final bool numeric;
  final bool primary;
  final String? footer;
}

class PColumn<T> {
  PColumn({
    required this.title,
    required this.contentBuilder,
    this.footer,
    this.flex = 1,
    this.numeric = false,
    this.primary = false,
  });

  final String title;
  final String? footer;
  final bool numeric;
  final bool primary;
  final String Function(T data, int index) contentBuilder;
  final int flex;
}

class PColumnFooter {
  PColumnFooter({
    this.footer,
    this.flex = 1,
    this.numeric = false,
    this.borderTransparent = false,
  });

  final String? footer;
  final bool numeric;
  final int flex;
  final bool borderTransparent;
}

class PColumnBody<T> {
  PColumnBody({
    required this.contentBuilder,
    this.flex = 1,
    this.numeric = false,
  });

  final bool numeric;
  final String Function(T data, int index) contentBuilder;
  final int flex;
}

class PColumnBodyN<T> {
  PColumnBodyN({
    required this.content,
    this.flex = 1,
    this.numeric = false,
  });

  final bool numeric;
  final String content;
  final int flex;
}

class PColumnHeader {
  PColumnHeader({
    required this.title,
    this.flex = 1,
    this.numeric = false,
    this.children,
    this.primary = false,
  });

  final String title;
  final bool numeric;
  final List<PColumnHeader>? children;
  final bool primary;
  final int flex;
}

// IMPROVED: Compact table body dengan padding lebih kecil
Widget tableBody<T>({
  required List<T> data,
  required List<PColumnBody<T>> columns,
  EdgeInsetsGeometry? padding,
}) {
  const paddingRow = EdgeInsets.symmetric(horizontal: 6, vertical: 2);

  final table = Table(
    border: TableBorder.all(color: PdfColors.grey200, width: 0.5),
    columnWidths: {
      for (var i = 0; i < columns.length; i++)
        i: FlexColumnWidth(columns[i].flex.toDouble()),
    },
    children: List<TableRow>.generate(
      data.length,
      (row) => TableRow(
        children: List<Widget>.generate(
          columns.length,
          (column) => Container(
            constraints: const BoxConstraints(minHeight: 20),
            padding: paddingRow,
            decoration: BoxDecoration(
              color: row.isEven ? PdfColors.grey50 : PdfColors.white,
            ),
            alignment: columns[column].numeric
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text(
              columns[column].contentBuilder(data[row], row),
              style: const TextStyle(fontSize: 7),
            ),
          ),
        ),
      ),
    ),
  );

  if (padding != null) {
    return Padding(padding: padding, child: table);
  } else {
    return table;
  }
}

// IMPROVED: Compact table body 2
List<Widget> tableBody2<T>({
  required List<T> data,
  required List<PColumnBody<T>> columns,
  EdgeInsetsGeometry? padding,
}) {
  const paddingRow = EdgeInsets.symmetric(horizontal: 6, vertical: 2);
  final children = <Widget>[];
  for (var i = 0; i < data.length; i++) {
    children.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Table(
          border: TableBorder.all(color: PdfColors.grey200, width: 0.5),
          columnWidths: {
            for (var i = 0; i < columns.length; i++)
              i: FlexColumnWidth(columns[i].flex.toDouble()),
          },
          children: [
            TableRow(
              children: List<Widget>.generate(
                columns.length,
                (column) => Container(
                  constraints: const BoxConstraints(minHeight: 20),
                  padding: paddingRow,
                  decoration: BoxDecoration(
                    color: i.isEven ? PdfColors.grey50 : PdfColors.white,
                  ),
                  alignment: columns[column].numeric
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    columns[column].contentBuilder(data[i], i),
                    style: const TextStyle(fontSize: 7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  return children;
}

Widget textGroup(String text) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: PdfColor.fromInt(flavorConfig.color.value),
    ),
  );
}

// IMPROVED: Simple table dengan style lebih compact
List<Widget> simpleTablePdf2<T>({
  required List<T> data,
  required List<PColumn<T>> columns,
  EdgeInsets? padding,
}) {
  Widget usePadding(Widget child) => Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 36),
        child: child,
      );

  final children = <Widget>[
    usePadding(
      tableHeader(
        columns: columns
            .map((e) => PColumnHeader(title: e.title, flex: e.flex))
            .toList(),
      ),
    ),
  ];
  for (var i = 0; i < data.length; i++) {
    children.add(
      usePadding(
        tableBody(
          data: [data[i]],
          columns: columns
              .map(
                (e) => PColumnBody<T>(
                  flex: e.flex,
                  contentBuilder: (d, i) => e.contentBuilder(d, i),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  return children;
}

@Deprecated('Use simpleTablePdf2 instead')
Table simpleTablePdf<T>({
  required List<T> data,
  required List<PColumn<T>> columns,
}) {
  final primaryColor = PdfColor.fromInt(flavorConfig.color.value);
  const paddingRow = EdgeInsets.symmetric(horizontal: 6, vertical: 2);
  final footer = <Widget>[
    for (final column in columns)
      Container(
        constraints: const BoxConstraints(minHeight: 22),
        padding: paddingRow,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
        child: Align(
          alignment:
              column.numeric ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            column.footer ?? '',
            textAlign: column.numeric ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
  ];

  return Table(
    border: TableBorder.all(color: PdfColors.grey200, width: 0.5),
    columnWidths: {
      for (var i = 0; i < columns.length; i++)
        i: FlexColumnWidth(columns[i].flex.toDouble()),
    },
    children: [
      TableRow(
        children: [
          for (final column in columns)
            Container(
              constraints: const BoxConstraints(minHeight: 24),
              padding: paddingRow,
              decoration: BoxDecoration(
                color: column.primary ? primaryColor : PdfColors.blueGrey700,
              ),
              child: Align(
                alignment: column.numeric
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  column.title,
                  textAlign: column.numeric ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      ...List<TableRow>.generate(
        data.length,
        (row) => TableRow(
          children: List<Widget>.generate(
            columns.length,
            (column) => Container(
              constraints: const BoxConstraints(minHeight: 20),
              padding: paddingRow,
              decoration: BoxDecoration(
                color: row.isEven ? PdfColors.grey50 : PdfColors.white,
              ),
              alignment: columns[column].numeric
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                columns[column].contentBuilder(data[row], row),
                style: const TextStyle(fontSize: 7),
              ),
            ),
          ),
        ),
      ),
      ...[TableRow(children: footer)],
    ],
  );
}

// IMPROVED: Table footer dengan style lebih compact
Widget tableFooter({
  required List<PColumnFooter> columns,
  EdgeInsetsGeometry? padding,
}) {
  final primaryColor = PdfColor.fromInt(flavorConfig.color.value);
  const paddingRow = EdgeInsets.symmetric(horizontal: 6, vertical: 2);
  final footer = <Widget>[
    for (final column in columns)
      Container(
        constraints: const BoxConstraints(minHeight: 22),
        padding: paddingRow,
        decoration: BoxDecoration(
          border: column.borderTransparent
              ? const Border()
              : Border(
                  top: BorderSide(color: primaryColor, width: 1.5),
                ),
        ),
        child: Align(
          alignment:
              column.numeric ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            column.footer ?? '',
            textAlign: column.numeric ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
  ];

  final table = Table(
    border: TableBorder.all(color: PdfColors.grey200, width: 0.5),
    columnWidths: {
      for (var i = 0; i < columns.length; i++)
        i: FlexColumnWidth(columns[i].flex.toDouble()),
    },
    children: [TableRow(children: footer)],
  );

  if (padding != null) {
    return Padding(padding: padding, child: table);
  } else {
    return table;
  }
}

// IMPROVED: Table header dengan style lebih compact
Widget tableHeader({
  required List<PColumnHeader> columns,
  EdgeInsetsGeometry? padding,
}) {
  final primaryColor = PdfColor.fromInt(flavorConfig.color.value);
  const paddingRow = EdgeInsets.symmetric(horizontal: 6, vertical: 2);
  final hasChildren = columns.any((e) => e.children?.isNotEmpty ?? false);

  final table = Table(
    border: TableBorder.all(color: PdfColors.grey200, width: 0.5),
    columnWidths: {
      for (var i = 0; i < columns.length; i++)
        i: FlexColumnWidth(columns[i].flex.toDouble()),
    },
    children: [
      TableRow(
        children: [
          for (final column in columns)
            Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    minHeight: hasChildren
                        ? (column.children?.isNotEmpty ?? false)
                            ? 24
                            : 48
                        : 24,
                  ),
                  padding: paddingRow,
                  decoration: BoxDecoration(
                    color:
                        column.primary ? primaryColor : PdfColors.blueGrey700,
                  ),
                  child: Align(
                    alignment: column.numeric
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      column.title,
                      textAlign:
                          column.numeric ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                ),
                if (column.children?.isNotEmpty ?? false)
                  tableHeader(columns: column.children!),
              ],
            ),
        ],
      ),
    ],
  );

  if (padding != null) {
    return Padding(
      padding: padding,
      child: table,
    );
  } else {
    return table;
  }
}

// IMPROVED: Table complex dengan style lebih compact
Table simpleTablePdfX<T>({
  required List<T> data,
  required List<PGroup<T>> columns,
  List<String>? total,
}) {
  final primaryColor = PdfColor.fromInt(flavorConfig.color.value);
  const paddingRow = EdgeInsets.symmetric(horizontal: 6, vertical: 2);
  final footer = <Widget>[
    for (final column in columns)
      Container(
        constraints: const BoxConstraints(minHeight: 22),
        padding: paddingRow,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
        child: Align(
          alignment:
              column.numeric ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            column.footer ?? '',
            textAlign: column.numeric ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
  ];

  return Table(
    border: TableBorder.all(color: PdfColors.grey200, width: 0.5),
    columnWidths: {
      for (var i = 0; i < columns.length; i++)
        i: columns[i].children.isEmpty || columns[i].children.length == 1
            ? const FlexColumnWidth(2)
            : FlexColumnWidth(columns[i].children.length.toDouble() * 2),
    },
    children: [
      TableRow(
        children: [
          for (final column in columns)
            Container(
              constraints: const BoxConstraints(minHeight: 24),
              padding: paddingRow,
              decoration: BoxDecoration(
                color: column.primary ? primaryColor : PdfColors.blueGrey700,
              ),
              child: Align(
                alignment: column.numeric
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  column.title ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      TableRow(
        children: [
          for (final column in columns)
            Row(
              children: [
                for (final subheader in column.children)
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 24),
                      padding: paddingRow,
                      margin: column.children.length > 1 &&
                              column.children.last.title != subheader.title
                          ? const EdgeInsets.only(right: 0.5)
                          : EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: subheader.primary
                            ? primaryColor
                            : PdfColors.blueGrey700,
                      ),
                      child: Align(
                        alignment: subheader.numeric
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          subheader.title,
                          textAlign: subheader.numeric
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
      ...List<TableRow>.generate(
        data.length,
        (row) => TableRow(
          children: List<Widget>.generate(
            columns.length,
            (column) => Row(
              children: List<Widget>.generate(
                columns[column].children.length,
                (x) => Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 20),
                    padding: paddingRow,
                    margin: columns[column].children.length > 1 &&
                            columns[column].children.last.title !=
                                columns[column].children[x].title
                        ? const EdgeInsets.only(right: 0.5)
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: row.isEven ? PdfColors.grey50 : PdfColors.white,
                    ),
                    alignment: columns[column].children[x].numeric
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      columns[column]
                          .children[x]
                          .contentBuilder(data[row], row),
                      style: const TextStyle(fontSize: 7),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      ...List<TableRow>.generate(
        1,
        (row) => TableRow(
          children: List<Widget>.generate(
            columns.length,
            (column) => Row(
              children: List<Widget>.generate(
                columns[column].children.length,
                (x) => Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 20),
                    padding: paddingRow,
                    margin: columns[column].children.length > 1 &&
                            columns[column].children.last.title !=
                                columns[column].children[x].title
                        ? const EdgeInsets.only(right: 0.5)
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: row.isEven ? PdfColors.grey50 : PdfColors.white,
                    ),
                    alignment: columns[column].children[x].numeric
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      'TOTAL',
                      style: const TextStyle(fontSize: 7),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      ...[TableRow(children: footer)],
    ],
  );
}

Widget tileDataHorizontal({
  required String label,
  required Widget child,
  double valueWidth = 100,
  bool labelRight = false,
  TextStyle? labelStyle,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment:
                labelRight ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              label,
              textAlign: labelRight ? TextAlign.end : TextAlign.start,
              maxLines: 1,
              style: labelStyle ??
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                  ),
            ),
          ),
        ),
        SizedBox(
          width: valueWidth,
          child: Align(
            alignment: Alignment.centerRight,
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 8,
              ),
              child: child,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<MultiPage> pdfTemplate({
  required List<Widget> Function(Context context) build,
  required String headerTitle,
  required String printedBy,
  Widget? headerChild,
  PageOrientation? orientation,
  PdfPageFormat? pageFormat = PdfPageFormat.a4,
  String? footerNote,
  String? qrCode,
  double paddingHorizontal = 36,
  bool isTitleFirst = false,
}) async {
  final (companyLogo, companyLogoNamed) = await getCompanyLogoPdf();
  return MultiPage(
    pageTheme: PageTheme(
      orientation: orientation,
      theme: ThemeData.withFont(
        base: await PdfGoogleFonts.openSansRegular(),
        bold: await PdfGoogleFonts.openSansBold(),
        icons: await PdfGoogleFonts.materialIcons(),
      ),
      pageFormat: pageFormat,
      margin: EdgeInsets.zero,
      buildBackground: (Context context) => Transform.translate(
        offset: const PdfPoint(-80, 0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 120),
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            color: PdfColor.fromInt(flavorConfig.color.lighten(.56).value),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ),
    header: (context) {
      if (isTitleFirst) {
        final title = context.pageNumber == 1 ? headerTitle : '';
        return PdfHeaderWidget(
          companyLogo: companyLogo,
          companyLogoNamed: companyLogoNamed,
          title: title,
          child: headerChild,
          qrCode: qrCode,
          paddingHorizontal: paddingHorizontal,
        );
      }
      return PdfHeaderWidget(
        companyLogo: companyLogo,
        companyLogoNamed: companyLogoNamed,
        title: headerTitle,
        child: headerChild,
        qrCode: qrCode,
        paddingHorizontal: paddingHorizontal,
      );
    },
    footer: (context) => footerPdf(
      context: context,
      printedBy: printedBy,
      footNote: footerNote,
      paddingHorizontal: paddingHorizontal,
    ),
    build: build,
  );
}
