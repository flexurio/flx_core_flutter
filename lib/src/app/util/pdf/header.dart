import 'package:flutter/services.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfHeaderWidget extends StatelessWidget {
  PdfHeaderWidget({
    required this.companyLogo,
    required this.companyLogoNamed,
    required this.title,
    this.child,
    this.qrCode,
    this.paddingHorizontal = 36,
  });

  final Uint8List companyLogo;
  final Uint8List companyLogoNamed;
  final String title;
  final double paddingHorizontal;
  final Widget? child;
  final String? qrCode;

  static const _textColor = PdfColors.blueGrey800;

  PdfColor get _primaryColor => PdfColor.fromInt(flavorConfig.color.value);
  PdfColor get _lightColor53 =>
      PdfColor.fromInt(flavorConfig.color.lighten(.53).value);
  PdfColor get _lightColor50 =>
      PdfColor.fromInt(flavorConfig.color.lighten(.5).value);
  PdfColor get _lightColor30 =>
      PdfColor.fromInt(flavorConfig.color.lighten(.3).value);

  @override
  Widget build(Context context) {
    return Stack(
      children: [
        ..._buildDecorations(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompanyHeader(),
            SizedBox(height: 12),
            _buildTitleSection(),
            if (child != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: child,
              )
            else
              SizedBox(height: 12),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildDecorations() {
    return [
      Positioned(
        top: -20,
        left: -20,
        child: _decorativeCircle(50, _lightColor53),
      ),
      Positioned(
        top: -40,
        left: -40,
        child: _decorativeCircle(90, _lightColor53),
      ),
      Positioned(
        top: -60,
        right: 0,
        child: Transform.rotate(
          angle: 4,
          child: Container(width: 60, height: 120, color: _lightColor50),
        ),
      ),
      Positioned(
        top: 30,
        right: -30,
        child: Transform.rotate(
          angle: 4,
          child: Container(width: 50, height: 50, color: _lightColor30),
        ),
      ),
      Positioned(
        top: 103,
        left: 0,
        child: Container(width: 250, height: 3, color: _primaryColor),
      ),
    ];
  }

  Widget _buildCompanyHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        paddingHorizontal,
        24,
        48,
        16,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _primaryColor)),
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
                _infoRow(0xe0b0, flavorConfig.companyPhone),
                SizedBox(height: 6),
                _infoRow(0xe894, flavorConfig.companyWebsite),
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
                        style: const TextStyle(fontSize: 8, color: _textColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(fontSize: 16, color: _textColor),
            ),
          ),
          if (qrCode != null) ...[
            SizedBox(width: 12),
            BarcodeWidget(
              data: qrCode!,
              barcode: Barcode.qrCode(),
              width: 28,
              height: 28,
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(int iconCode, String text) {
    return Row(
      children: [
        Icon(IconData(iconCode), size: 10, color: PdfColors.blueGrey400),
        SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 8, color: _textColor),
        ),
      ],
    );
  }

  Widget _decorativeCircle(double size, PdfColor color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(width: 8, color: color),
        shape: BoxShape.circle,
      ),
    );
  }
}
