import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Widget headerPdf({
  required Uint8List companyLogo,
  required Uint8List companyLogoNamed,
  required String title,
}) {
  const color = PdfColors.blueGrey800;
  final primaryColor = PdfColor.fromInt(flavorConfig.color.value);
  return Stack(
    children: [
      Positioned(
        top: -20,
        left: -20,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              width: 8,
              color: PdfColor.fromInt(flavorConfig.color.lighten(.53).value),
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
      Positioned(
        top: -40,
        left: -40,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(
              width: 8,
              color: PdfColor.fromInt(flavorConfig.color.lighten(.53).value),
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
      Positioned(
        top: -60,
        right: 0,
        child: Transform.rotate(
          angle: 4, // 90 degree
          child: Container(
            width: 60,
            height: 120,
            color: PdfColor.fromInt(flavorConfig.color.lighten(.5).value),
          ),
        ),
      ),
      Positioned(
        top: 30,
        right: -30,
        child: Transform.rotate(
          angle: 4,
          child: Container(
            width: 50,
            height: 50,
            color: PdfColor.fromInt(flavorConfig.color.lighten(.3).value),
          ),
        ),
      ),
      Positioned(
        top: 103,
        left: 0,
        child: Container(
          width: 250,
          height: 3,
          color: primaryColor,
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 24, left: 36, right: 48, bottom: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: primaryColor,
                ),
              ),
            ),
            child: Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image(MemoryImage(companyLogo), width: 38, height: 38),
                    Image(MemoryImage(companyLogoNamed), height: 36),
                  ],
                ),
                Spacer(),
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            const IconData(0xe0b0),
                            size: 10,
                            color: PdfColors.blueGrey400,
                          ),
                          SizedBox(width: 6),
                          Text(
                            flavorConfig.companyPhone,
                            style: const TextStyle(
                              fontSize: 8,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            const IconData(0xe894),
                            size: 10,
                            color: PdfColors.blueGrey400,
                          ),
                          SizedBox(width: 6),
                          Text(
                            flavorConfig.companyWebsite,
                            style: const TextStyle(
                              fontSize: 8,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            const IconData(0xe0c8),
                            size: 10,
                            color: PdfColors.blueGrey400,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              flavorConfig.companyAddress,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 8,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                color: PdfColors.blueGrey800,
              ),
            ),
          ),
          SizedBox(height: 6),
        ],
      ),
    ],
  );
}
