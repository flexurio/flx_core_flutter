import 'package:flutter/material.dart';

const colorEditButton = Colors.orange;
const colorDeleteButton = Colors.red;

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
