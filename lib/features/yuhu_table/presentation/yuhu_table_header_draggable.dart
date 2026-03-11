import 'package:flx_core_flutter/features/yuhu_table/presentation/table_column.dart';
import 'package:flx_core_flutter/features/yuhu_table/presentation/table_header.dart';
import 'package:flutter/material.dart';

class YuhuTableDraggableHeader<T> extends StatelessWidget {
  const YuhuTableDraggableHeader({
    required this.index,
    required this.column,
    required this.isSort,
    required this.ascending,
    required this.pinnedPosition,
    required this.currentWidth,
    required this.headerDecoration,
    required this.onPinnedPositionChanged,
    required this.onColorChanged,
    required this.onResizing,

    required this.onTap,
    required this.onDrop,
    super.key,
  });

  final int index;
  final TableColumn<T> column;
  final bool isSort;
  final bool ascending;
  final TablePinPosition pinnedPosition;
  final double currentWidth;
  final BoxDecoration headerDecoration;
  final void Function(TablePinPosition)? onPinnedPositionChanged;
  final void Function(Color?)? onColorChanged;
  final void Function(double delta)? onResizing;

  final void Function()? onTap;
  final void Function(int fromIndex) onDrop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final header = TableHeader(
      column: column,
      ascending: ascending,
      isSort: isSort,
      pinnedPosition: pinnedPosition,
      onPinnedPositionChanged: onPinnedPositionChanged,
      onColorChanged: onColorChanged,
      onResizing: onResizing,

      onTap: onTap,
    );


    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => details.data != index,
      onAcceptWithDetails: (details) => onDrop(details.data),
      builder: (context, candidateData, rejectedData) {
        final isOver = candidateData.isNotEmpty;

        return Draggable<int>(
          data: index,
          feedback: Material(
            elevation: 8,
            color: theme.cardColor,
            child: Container(
              width: currentWidth,
              decoration: headerDecoration,
              child: header,
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: header,
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.grab,
            child: Container(
              decoration: BoxDecoration(
                border: isOver
                    ? Border(
                        left: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 3,
                        ),
                      )
                    : null,
              ),
              child: header,
            ),
          ),
        );
      },
    );
  }
}
