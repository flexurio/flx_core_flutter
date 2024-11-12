import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget pullRight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [this],
    );
  }
}
