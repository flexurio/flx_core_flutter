import 'package:flutter/material.dart';

class SizedText extends StatelessWidget {
  const SizedText(this.text, {this.width, super.key});

  final String text;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 200,
      child: Tooltip(
        message: text,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
