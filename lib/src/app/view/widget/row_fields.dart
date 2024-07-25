import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RowFields extends StatelessWidget {
  const RowFields({
    required this.children,
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return Container();

    final list = <Widget>[];
    for (final element in children) {
      list.addAll([
        Expanded(child: element),
        const Gap(24),
      ]);
    }
    list.removeLast();

    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: list,
    );
  }
}
