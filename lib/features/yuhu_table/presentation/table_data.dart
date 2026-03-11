import 'package:flutter/material.dart';

class TableData extends StatelessWidget {
  const TableData({
    required this.child,
    required this.height,
    required this.alignment,
    required this.borderSide,
    this.backgroundColor,
    super.key,
  });

  final Widget child;
  final double height;
  final Alignment alignment;
  final BorderSide borderSide;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: borderSide,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Align(
        alignment: alignment,
        child: child,
      ),
    );
  }
}
