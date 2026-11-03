import 'package:flutter/material.dart';

const colorEditButton = Colors.orange;
const colorDeleteButton = Colors.red;

const listViewColor = Color(0xffA1D0F5);
const disabledFontColor = Colors.black54;
const dialogBackgroundColor = Colors.white;
const disabledColor = Colors.black54;
const formColor = Color(0xffECECEC);
const inputCardColor = Color(0xffB0BFC4);
const blueFontColor = Color(0xff3393E1);
const tileColor = Colors.white;
const transparentColor = Colors.transparent;
final barrierColor = Colors.black.withValues(alpha: 0.5);
const listBlueColor = Color(0xff57BFEB);
const listGrayColor = Color.fromARGB(255, 135, 135, 135);
const listRedColor = Color.fromARGB(255, 235, 87, 87);

extension ColorBrightness on Color {
  Color darken(double amount) {
    assert(amount >= 0 && amount <= 1, 'amount is between 0 and 1');
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten(double amount) {
    assert(amount >= 0 && amount <= 1, 'amount is between 0 and 1');
    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}

Color colorFromHex(String hexColor) {
  var hex = hexColor.toUpperCase().replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex';
  }
  return Color(int.parse(hex, radix: 16));
}
