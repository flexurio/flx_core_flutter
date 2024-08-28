import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';

class TileDataHorizontal extends StatelessWidget {
  const TileDataHorizontal({
    required this.label,
    required this.child,
    this.inverseColor = false,
    super.key,
    this.labelStyle,
    this.valueWidth = 220,
    this.labelRight = true,
  });

  final String label;
  final Widget child;
  final TextStyle? labelStyle;
  final bool inverseColor;
  final double valueWidth;
  final bool labelRight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Align(
              alignment:
                  labelRight ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                label,
                textAlign: labelRight ? TextAlign.end : TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle ??
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: inverseColor
                          ? Colors.white70
                          : theme.modeCondition(Colors.black38, Colors.white30),
                      fontSize: 14,
                    ),
              ),
            ),
          ),
          SizedBox(
            width: valueWidth,
            child: Align(
              alignment: Alignment.centerRight,
              child: DefaultTextStyle(
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: inverseColor
                      ? theme.colorScheme.primary.lighten(.15)
                      : null,
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TileDataVertical extends StatelessWidget {
  const TileDataVertical({
    required this.label,
    required this.child,
    super.key,
    this.bordered = false,
    this.strong = false,
    this.titleRight = false,
  });

  factory TileDataVertical.titleRight({
    required String label,
    required Widget child,
  }) {
    return TileDataVertical(
      label: label,
      strong: true,
      titleRight: true,
      child: child,
    );
  }

  final String label;
  final Widget child;
  final bool bordered;
  final bool strong;
  final bool titleRight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Align(
      alignment: Alignment.topLeft,
      child: Container(
        constraints: const BoxConstraints(minHeight: 34),
        child: child,
      ),
    );
    return DecoratedBox(
      decoration: bordered
          ? BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            )
          : const BoxDecoration(),
      child: ListTile(
        contentPadding: strong ? EdgeInsets.zero : null,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: strong ? 12 : 0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: strong
                  ? theme.textTheme.bodyMedium?.color
                  : theme.modeCondition(Colors.black38, Colors.white30),
              fontSize: 14,
            ),
            textAlign: titleRight ? TextAlign.end : TextAlign.start,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: strong ? 12 : 3),
          child: strong
              ? child
              : DefaultTextStyle(
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  child: content,
                ),
        ),
      ),
    );
  }
}
