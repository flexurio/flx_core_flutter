import 'package:flutter/material.dart';

enum TablePinPosition { none, left, right }

class TableColumn<T> {
  TableColumn({
    required this.title,
    required this.builder,
    this.sortString,
    this.sortNum,
    this.alignment = Alignment.centerLeft,
    this.width,
    this.flex,
    this.backgroundColor,
    // Set to true for columns whose cell child manages its own padding
    // (e.g. full-cell background-color containers) so TableData skips the
    // default 12 px horizontal padding and the color fills edge-to-edge.
    this.zeroPadding = false,
  });

  final String title;
  final Alignment alignment;
  final double? width;
  final int? flex;
  final String Function(T)? sortString;
  final num Function(T)? sortNum;
  final Widget Function(T, int) builder;
  final Color? backgroundColor;
  final bool zeroPadding;
}
