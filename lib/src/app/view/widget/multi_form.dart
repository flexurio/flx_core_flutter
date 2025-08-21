import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MultiForm extends StatelessWidget {
  const MultiForm({
    required this.children,
    required this.titles,
    required this.page,
    super.key,
  });

  final List<Widget> children;
  final List<String> titles;
  final int page;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: _TimeLine(
            items: titles,
            value: page,
          ),
        ),
        ...List.generate(children.length, (index) {
          return Visibility(
            visible: index == page,
            maintainState: true,
            child: children[index],
          );
        }),
      ],
    );
  }
}

class _TimeLine extends StatelessWidget {
  const _TimeLine({
    required this.items,
    required this.value,
  });

  final List<String> items;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.colorScheme.secondary;
    final lineColor =
        theme.modeCondition(Colors.grey.shade200, MyTheme.black06dp);
    final children = <Widget>[];
    final itemsLength = items.length;
    for (var i = 0; i < itemsLength; i++) {
      children.add(
        TimelineTile(
          axis: TimelineAxis.horizontal,
          endChild: Container(
            padding: const EdgeInsets.only(top: 14),
            width: 100,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                items[i],
                style: TextStyle(
                  fontWeight: i == value ? FontWeight.bold : null,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          isFirst: i == 0,
          isLast: i == itemsLength - 1,
          afterLineStyle: LineStyle(
            color: i < value ? secondaryColor.withOpacity(.3) : lineColor,
          ),
          beforeLineStyle: LineStyle(
            color: i <= value ? secondaryColor.withOpacity(.3) : lineColor,
          ),
          indicatorStyle: IndicatorStyle(
            height: 30,
            width: 30,
            color: i <= value ? secondaryColor : lineColor,
            iconStyle: IconStyle(
              fontSize: 20,
              color: i <= value
                  ? theme.cardColor
                  : theme.modeCondition(Colors.grey.shade400, Colors.white24),
              iconData: i == value ? Icons.circle_outlined : Icons.check,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
