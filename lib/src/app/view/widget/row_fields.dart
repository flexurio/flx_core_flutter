import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RowFields extends StatelessWidget {
  const RowFields({
    required this.children,
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return Container();

    final isStart = mainAxisAlignment == MainAxisAlignment.start;

    final list = <Widget>[];
    for (final element in children) {
      list.addAll([
        if (isStart) Expanded(child: element) else element,
        Gap(isStart ? 24 : 12),
      ]);
    }
    list.removeLast();

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: list,
    );
  }
}
