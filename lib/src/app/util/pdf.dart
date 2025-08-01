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
}) {
  final now = DateTime.now();
  final primaryColor = PdfColor.fromInt(flavorConfig.color.value);
  return Stack(
    children: [
      Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Authorized Access:',
                        style: TextStyle(
                          fontSize: 10,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Only authorized personnel who have been specifically granted permission and have completed the necessary confidentiality training are allowed to print, handle, or view confidential documents. This ensures that sensitive information is protected from unauthorized access and potential breaches of confidentiality.',
                        style: const TextStyle(
                          fontSize: 8,
                          color: PdfColors.blueGrey800,
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
              color: PdfColors.blueGrey50,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Printed by: $printedBy',
                        style: const TextStyle(
                          fontSize: 8,
                          color: PdfColors.blueGrey800,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Printed on: ${now.yMMMdHm} '
                        'GMT+${now.timeZoneOffset.inHours}',
                        style: const TextStyle(
                          fontSize: 8,
                          color: PdfColors.blueGrey800,
                        ),
                      ),
                    ],
                  ),
                  if (footNote != null)
                    Text(
                      footNote,
                      style: const TextStyle(
                        fontSize: 8,
                        color: PdfColors.blueGrey800,
                      ),
                    ),
                  Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: const TextStyle(
                      fontSize: 8,
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
          height: 200,
          width: 6,
          color: PdfColor.fromInt(flavorConfig.color.lighten(.45).value),
        ),
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          height: 46.2,
          width: 6,
          color: PdfColor.fromInt(flavorConfig.color.lighten(.3).value),
        ),
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Container(width: 250, height: 2, color: primaryColor),
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

Widget tableBody<T>({
  required List<T> data,
  required List<PColumnBody<T>> columns,
  EdgeInsetsGeometry? padding,
}) {
  const paddingRow = EdgeInsets.symmetric(horizontal: 8);

  final table = Table(
    border: TableBorder.all(color: PdfColors.white, width: 3),
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
            height: 30,
            padding: paddingRow,
            decoration: BoxDecoration(
              color: row.isEven ? PdfColors.grey100 : PdfColors.white,
              border: Border.all(
                width: 4,
                color: PdfColors.grey100,
              ),
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

List<Widget> tableBody2<T>({
  required List<T> data,
  required List<PColumnBody<T>> columns,
  EdgeInsetsGeometry? padding,
}) {
  const paddingRow = EdgeInsets.symmetric(horizontal: 8);
  final children = <Widget>[];
  for (var i = 0; i < data.length; i++) {
    children.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Table(
          border: TableBorder.all(color: PdfColors.white, width: 3),
          columnWidths: {
            for (var i = 0; i < columns.length; i++)
              i: FlexColumnWidth(columns[i].flex.toDouble()),
          },
          children: [
            TableRow(
              children: List<Widget>.generate(
                columns.length,
                (column) => Container(
                  height: 30,
                  padding: paddingRow,
                  decoration: BoxDecoration(
                    color: i.isEven ? PdfColors.grey100 : PdfColors.white,
                    border: Border.all(
                      width: 4,
                      color: PdfColors.grey100,
                    ),
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
  const paddingRow = EdgeInsets.symmetric(horizontal: 8);
  final footer = <Widget>[
    for (final column in columns)
      Container(
        height: 30,
        padding: paddingRow,
        decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(color: PdfColors.blueGrey500, width: 4)),
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
    border: TableBorder.all(color: PdfColors.white, width: 3),
    columnWidths: {
      for (var i = 0; i < columns.length; i++)
        i: FlexColumnWidth(columns[i].flex.toDouble()),
    },
    children: [
      TableRow(
        children: [
          for (final column in columns)
            Container(
              height: 30,
              padding: paddingRow,
              decoration: BoxDecoration(
                color: column.primary ? primaryColor : PdfColors.blueGrey800,
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
              height: 30,
              padding: paddingRow,
              decoration: BoxDecoration(
                color: row.isEven ? PdfColors.grey100 : PdfColors.white,
                border: Border.all(
                  width: 4,
                  color: PdfColors.grey100,
                ),
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

Widget tableFooter({
  required List<PColumnFooter> columns,
  EdgeInsetsGeometry? padding,
}) {
  const paddingRow = EdgeInsets.symmetric(horizontal: 8);
  final footer = <Widget>[
    for (final column in columns)
      Container(
        height: 30,
        padding: paddingRow,
        decoration: BoxDecoration(
          border: column.borderTransparent
              ? const Border()
              : const Border(
                  top: BorderSide(color: PdfColors.blueGrey500, width: 4),
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
    border: TableBorder.all(color: PdfColors.white, width: 3),
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

Widget tableHeader({
  required List<PColumnHeader> columns,
  EdgeInsetsGeometry? padding,
}) {
  final primaryColor = PdfColor.fromInt(flavorConfig.color.value);
  const paddingRow = EdgeInsets.symmetric(horizontal: 8);
  final hasChildren = columns.any((e) => e.children?.isNotEmpty ?? false);

  final table = Table(
    border: TableBorder.all(color: PdfColors.white, width: 3),
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
                  height: hasChildren
                      ? (column.children?.isNotEmpty ?? false)
                          ? 30
                          : 60
                      : 30,
                  padding: paddingRow,
                  decoration: BoxDecoration(
                    color:
                        column.primary ? primaryColor : PdfColors.blueGrey800,
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

Table simpleTablePdfX<T>({
  required List<T> data,
  required List<PGroup<T>> columns,
  List<String>? total,
}) {
  final primaryColor = PdfColor.fromInt(flavorConfig.color.value);
  const paddingRow = EdgeInsets.symmetric(horizontal: 8);
  final footer = <Widget>[
    for (final column in columns)
      Container(
        height: 30,
        padding: paddingRow,
        decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(color: PdfColors.blueGrey500, width: 4)),
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
    border: TableBorder.all(color: PdfColors.white, width: 3),
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
              height: 30,
              padding: paddingRow,
              decoration: BoxDecoration(
                color: column.primary ? primaryColor : PdfColors.blueGrey800,
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
                      height: 30,
                      padding: paddingRow,
                      margin: column.children.length > 1 &&
                              column.children.last.title != subheader.title
                          ? const EdgeInsets.only(right: 3)
                          : EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: subheader.primary
                            ? primaryColor
                            : PdfColors.blueGrey800,
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
                (x) =>
                    //
                    Expanded(
                  child: Container(
                    height: 30,
                    padding: paddingRow,
                    margin: columns[column].children.length > 1 &&
                            columns[column].children.last.title !=
                                columns[column].children[x].title
                        ? const EdgeInsets.only(right: 3)
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: row.isEven ? PdfColors.grey100 : PdfColors.white,
                      border: Border.all(
                        width: 4,
                        color: PdfColors.grey100,
                      ),
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

                //
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
                (x) =>
                    //
                    Expanded(
                  child: Container(
                    height: 30,
                    padding: paddingRow,
                    margin: columns[column].children.length > 1 &&
                            columns[column].children.last.title !=
                                columns[column].children[x].title
                        ? const EdgeInsets.only(right: 3)
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: row.isEven ? PdfColors.grey100 : PdfColors.white,
                      border: Border.all(
                        width: 4,
                        color: PdfColors.grey100,
                      ),
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
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
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
                    // color: inverseColor
                    //     ? Colors.white70
                    //     : theme.modeCondition(Colors.black38, Colors.white30),
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
}) async {
  final (companyLogo, companyLogoNamed) = await getCompanyLogoPdf();
  return MultiPage(
    pageTheme: PageTheme(
      orientation: orientation,
      theme: ThemeData.withFont(
        base: await PdfGoogleFonts.openSansLight(),
        bold: await PdfGoogleFonts.openSansSemiBold(),
        icons: await PdfGoogleFonts.materialIcons(),
      ),
      pageFormat: pageFormat,
      margin: EdgeInsets.zero,
      buildBackground: (Context context) => Transform.translate(
        offset: const PdfPoint(-100, 0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 140),
          height: 220,
          width: 220,
          decoration: BoxDecoration(
            color: PdfColor.fromInt(flavorConfig.color.lighten(.56).value),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ),
    header: (context) => headerPdf(
      companyLogo: companyLogo,
      companyLogoNamed: companyLogoNamed,
      title: headerTitle,
      child: headerChild,
    ),
    footer: (context) =>
        footerPdf(context: context, printedBy: printedBy, footNote: footerNote),
    build: build,
  );
}
