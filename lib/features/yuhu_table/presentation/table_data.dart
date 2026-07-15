import 'package:flutter/material.dart';

class TableData extends StatelessWidget {
  const TableData({
    required this.child,
    required this.height,
    required this.alignment,
    required this.borderSide,
    this.showRightBorder = false,
    this.backgroundColor,
    // Defaults to the original 12 px horizontal padding.
    // Pass EdgeInsets.zero for cells whose child manages its own padding
    // (e.g. full-cell background-color containers).
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    super.key,
  });

  final Widget child;
  final double height;
  final Alignment alignment;
  final BorderSide borderSide;
  final bool showRightBorder;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: borderSide,
          right: showRightBorder ? borderSide : BorderSide.none,
        ),
      ),
      padding: padding,
      child: Align(
        alignment: alignment,
        child: child,
      ),
    );
  }
}
