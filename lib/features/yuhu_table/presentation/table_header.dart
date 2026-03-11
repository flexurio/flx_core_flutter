import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

class TableHeader<T> extends StatelessWidget {
  const TableHeader({
    required this.column,
    required this.isSort,
    required this.ascending,
    super.key,
    this.onTap,
    this.isPinned = false,
    this.onPinChanged,
    this.onResizing,
    this.onResizeEnd,
  });

  final TableColumn<T> column;
  final void Function()? onTap;
  final void Function(bool)? onPinChanged;
  final void Function(double delta)? onResizing;
  final void Function()? onResizeEnd;
  final bool isSort;
  final bool ascending;
  final bool isPinned;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Align(
              alignment: column.alignment,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      column.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.modeCondition(
                          const Color(0xff374259),
                          Colors.blueGrey.shade200,
                        ),
                      ),
                    ),
                  ),
                  if (isSort)
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Icon(
                        ascending ? Icons.arrow_downward : Icons.arrow_upward,
                        size: 16,
                        color: primaryColor.withAlpha(120),
                      ),
                    ),
                  if (onPinChanged != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                          size: 16,
                          color: primaryColor.withAlpha(isPinned ? 180 : 80),
                        ),
                        onPressed: () => onPinChanged!(!isPinned),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        // Resize Handle
        if (onResizing != null)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                onResizing!(details.delta.dx);
              },
              onHorizontalDragEnd: (_) {
                onResizeEnd?.call();
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: Container(
                  width: 8,
                  color: Colors.transparent,
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 2,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.dividerColor.withAlpha(51),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
