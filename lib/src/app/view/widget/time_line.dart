import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLine extends StatelessWidget {
  const TimeLine({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final items = <Widget>[];
    final itemsLength = children.length;
    for (var i = 0; i < itemsLength; i++) {
      items.add(
        TimelineTile(
          isFirst: i == 0,
          isLast: i == itemsLength - 1,
          lineXY: 1,
          afterLineStyle: LineStyle(color: primaryColor.withOpacity(.5)),
          beforeLineStyle: LineStyle(color: primaryColor.withOpacity(.5)),
          indicatorStyle: IndicatorStyle(color: primaryColor),
          endChild: children[i],
        ),
      );
    }

    return Column(children: items);
  }
}
