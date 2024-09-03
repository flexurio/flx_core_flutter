import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/services.dart';
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

Widget footerPdf({required Context context, required String printedBy}) {
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
                children: [
                  Expanded(
                    child: Column(
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
                          'Printed on: ${now.yMMMdHm} GMT+${now.timeZoneOffset.inHours}',
                          style: const TextStyle(
                            fontSize: 8,
                            color: PdfColors.blueGrey800,
                          ),
                        ),
                      ],
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
  });

  final List<PColumn<T>> children;
  final String? title;
  final bool numeric;
  final bool primary;
}

class PColumn<T> {
  PColumn({
    required this.title,
    required this.contentBuilder,
    this.footer,
    this.numeric = false,
    this.primary = false,
  });

  final String title;
  final String? footer;
  final bool numeric;
  final bool primary;
  final String Function(T data, int index) contentBuilder;
}

Table simpleTablePdfX<T>({
  required List<T> data,
  // required List<PColumn<T>> columns,
  required List<PGroup<T>> columns,
}) {
  final primaryColor = PdfColor.fromInt(flavorConfig.color.value);
  const paddingRow = EdgeInsets.symmetric(horizontal: 8);
  // final footer = <Widget>[
  //   for (final column in columns)
  //     Container(
  //       height: 30,
  //       padding: paddingRow,
  //       decoration: const BoxDecoration(
  //         border:
  //             Border(top: BorderSide(color: PdfColors.blueGrey500, width: 4)),
  //       ),
  //       child: Align(
  //         alignment:
  //             column.numeric ? Alignment.centerRight : Alignment.centerLeft,
  //         child: Text(
  //           column.footer ?? '',
  //           textAlign: column.numeric ? TextAlign.right : TextAlign.left,
  //           style: TextStyle(
  //             fontSize: 7,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     ),
  // ];

  return Table(
    border: TableBorder.all(color: PdfColors.white, width: 3),
    columnWidths: {
      for (var i = 0; i < columns.length; i++) i: const FlexColumnWidth(2),
    },
    children: [
      TableRow(
        children: [
          for (final column in columns)
            Column(
              children: [
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
                      textAlign: column.numeric ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(column.children.length, (x) {
                    return Container(
                      height: 30,
                      padding: paddingRow,
                      decoration: BoxDecoration(
                        color: column.children[x].primary 
                          ? primaryColor 
                          : PdfColors.blueGrey800,
                      ),
                      child: Align(
                        alignment: column.children[x].numeric
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          column.children[x].title,
                          textAlign: column.children[x].numeric 
                            ? TextAlign.right 
                            : TextAlign.left,
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
        ],
      ),
      // TableRow(
      //   children: [
      //     for (final column in columns)
      //       Container(
      //         height: 30,
      //         padding: paddingRow,
      //         decoration: BoxDecoration(
      //           color: column.primary ? primaryColor : PdfColors.blueGrey800,
      //         ),
      //         child: Align(
      //           alignment: column.numeric
      //               ? Alignment.centerRight
      //               : Alignment.centerLeft,
      //           child: Text(
      //             column.title,
      //             textAlign: column.numeric ? TextAlign.right : TextAlign.left,
      //             style: TextStyle(
      //               fontSize: 7,
      //               fontWeight: FontWeight.bold,
      //               color: PdfColors.white,
      //             ),
      //           ),
      //         ),
      //       ),
      //   ],
      // ),
      // ...List<TableRow>.generate(
      //   data.length,
      //   (row) => TableRow(
      //     children: List<Widget>.generate(
      //       columns.length,
      //       (column) => Container(
      //         height: 30,
      //         padding: paddingRow,
      //         decoration: BoxDecoration(
      //           color: row.isEven ? PdfColors.grey100 : PdfColors.white,
      //           border: Border.all(
      //             width: 4,
      //             color: PdfColors.grey100,
      //           ),
      //         ),
      //         alignment: columns[column].numeric
      //             ? Alignment.centerRight
      //             : Alignment.centerLeft,
      //         child: Text(
      //           columns[column].contentBuilder(data[row], row),
      //           style: const TextStyle(fontSize: 7),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // ...[TableRow(children: footer)],
    ],
  );
}

Table simpleTablePdf<T>({
  required List<T> data,
  required List<PColumn<T>> columns,
}) {
  final primaryColor = PdfColor.fromInt(flavorConfig.color.value);
  const paddingRow = EdgeInsets.symmetric(horizontal: 8);
  // final footer = <Widget>[
  //   for (final column in columns)
  //     Container(
  //       height: 30,
  //       padding: paddingRow,
  //       decoration: const BoxDecoration(
  //         border:
  //             Border(top: BorderSide(color: PdfColors.blueGrey500, width: 4)),
  //       ),
  //       child: Align(
  //         alignment:
  //             column.numeric ? Alignment.centerRight : Alignment.centerLeft,
  //         child: Text(
  //           column.footer ?? '',
  //           textAlign: column.numeric ? TextAlign.right : TextAlign.left,
  //           style: TextStyle(
  //             fontSize: 7,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     ),
  // ];

  return Table(
    border: TableBorder.all(color: PdfColors.white, width: 3),
    columnWidths: {
      for (var i = 0; i < columns.length; i++) i: const FlexColumnWidth(2),
    },
    children: [
      // TableRow(
      //   children: [
      //     for (final column in columns)
      //       Container(
      //         height: 30,
      //         padding: paddingRow,
      //         decoration: BoxDecoration(
      //           color: column.primary ? primaryColor : PdfColors.blueGrey800,
      //         ),
      //         child: Align(
      //           alignment: column.numeric
      //               ? Alignment.centerRight
      //               : Alignment.centerLeft,
      //           child: Text(
      //             column.title,
      //             textAlign: column.numeric ? TextAlign.right : TextAlign.left,
      //             style: TextStyle(
      //               fontSize: 7,
      //               fontWeight: FontWeight.bold,
      //               color: PdfColors.white,
      //             ),
      //           ),
      //         ),
      //       ),
      //   ],
      // ),
      // ...List<TableRow>.generate(
      //   data.length,
      //   (row) => TableRow(
      //     children: List<Widget>.generate(
      //       columns.length,
      //       (column) => Container(
      //         height: 30,
      //         padding: paddingRow,
      //         decoration: BoxDecoration(
      //           color: row.isEven ? PdfColors.grey100 : PdfColors.white,
      //           border: Border.all(
      //             width: 4,
      //             color: PdfColors.grey100,
      //           ),
      //         ),
      //         alignment: columns[column].numeric
      //             ? Alignment.centerRight
      //             : Alignment.centerLeft,
      //         child: Text(
      //           columns[column].contentBuilder(data[row], row),
      //           style: const TextStyle(fontSize: 7),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // ...[TableRow(children: footer)],
    ],
  );
}

Future<MultiPage> pdfTemplate({
  required Widget child,
  required String title,
  required String printedBy,
  PageOrientation? orientation,
}) async {
  final (companyLogo, companyLogoNamed) = await getCompanyLogoPdf();
  return MultiPage(
    pageTheme: PageTheme(
      orientation: orientation,
      theme: ThemeData.withFont(
        base: await PdfGoogleFonts.openSansLight(),
        bold: await PdfGoogleFonts.openSansSemiBold(),
        icons: await PdfGoogleFonts.materialIcons(), // this line
      ),
      pageFormat: PdfPageFormat.a4,
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
      title: title,
    ),
    footer: (context) => footerPdf(context: context, printedBy: printedBy),
    build: (context) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: child,
        ),
      ]; // Ce
    },
  );
}
