
import 'package:flutter/material.dart';

class TableColumn<T> {
  TableColumn({
    required this.title,
    required this.builder,
    this.sortString,
    this.sortNum,
    this.alignment = Alignment.centerLeft,
    this.width,
  });

  final String title;
  final Alignment alignment;
  final double? width;
  final String Function(T)? sortString;
  final num Function(T)? sortNum;
  final Widget Function(T, int) builder;
}
