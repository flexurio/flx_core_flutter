import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

class TableHeader<T> extends StatefulWidget {
  const TableHeader({
    required this.column,
    required this.isSort,
    required this.ascending,
    super.key,
    this.onTap,
    this.pinnedPosition = TablePinPosition.none,
    this.onPinnedPositionChanged,
    this.onResizing,
    this.onResizeEnd,
  });

  final TableColumn<T> column;
  final void Function()? onTap;
  final void Function(TablePinPosition)? onPinnedPositionChanged;
  final void Function(double delta)? onResizing;
  final void Function()? onResizeEnd;
  final bool isSort;
  final bool ascending;
  final TablePinPosition pinnedPosition;

  @override
  State<TableHeader<T>> createState() => _TableHeaderState<T>();
}

class _TableHeaderState<T> extends State<TableHeader<T>> {
  bool _isHovered = false;

  void _showContextMenu(BuildContext context, Offset position) {
    if (widget.onPinnedPositionChanged == null) return;

    final theme = Theme.of(context);
    final overlay = Overlay.of(context);
    final RenderBox? overlayRenderBox =
        overlay.context.findRenderObject() as RenderBox?;

    if (overlayRenderBox == null) return;

    // Convert screen coordinates to overlay-local coordinates for perfect accuracy
    final Offset localOffset = overlayRenderBox.globalToLocal(position);
    final RelativeRect menuPosition = RelativeRect.fromLTRB(
      localOffset.dx,
      localOffset.dy,
      overlayRenderBox.size.width - localOffset.dx,
      overlayRenderBox.size.height - localOffset.dy,
    );

    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.onSurface,
      letterSpacing: 0.2,
    );

    showMenu<TablePinPosition>(
      context: context,
      position: menuPosition,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: .15),
          width: 0.8,
        ),
      ),
      elevation: 20,
      shadowColor: Colors.black.withValues(alpha: .3),
      color: theme.colorScheme.surface.withValues(alpha: 0.98),
      items: [
        _buildPopupHeader(widget.column.title),
        const PopupMenuDivider(height: 1),
        if (widget.pinnedPosition == TablePinPosition.none) ...[
          _buildPopupItem(
            value: TablePinPosition.left,
            icon: Icons.align_horizontal_left_rounded,
            label: 'Freeze to Left',
            style: textStyle,
          ),
          _buildPopupItem(
            value: TablePinPosition.right,
            icon: Icons.align_horizontal_right_rounded,
            label: 'Freeze to Right',
            style: textStyle,
          ),
        ] else if (widget.pinnedPosition == TablePinPosition.left) ...[
          _buildPopupItem(
            value: TablePinPosition.none,
            icon: Icons.pin_end_rounded,
            label: 'Unfreeze Column',
            style: textStyle,
          ),
          _buildPopupItem(
            value: TablePinPosition.right,
            icon: Icons.keyboard_double_arrow_right_rounded,
            label: 'Move to Right Pin',
            style: textStyle,
          ),
        ] else if (widget.pinnedPosition == TablePinPosition.right) ...[
          _buildPopupItem(
            value: TablePinPosition.none,
            icon: Icons.pin_end_rounded,
            label: 'Unfreeze Column',
            style: textStyle,
          ),
          _buildPopupItem(
            value: TablePinPosition.left,
            icon: Icons.keyboard_double_arrow_left_rounded,
            label: 'Move to Left Pin',
            style: textStyle,
          ),
        ],
      ],
    ).then((value) {
      if (value != null) {
        widget.onPinnedPositionChanged!(value);
      }
    });
  }

  PopupMenuEntry<TablePinPosition> _buildPopupHeader(String title) {
    return PopupMenuItem<TablePinPosition>(
      enabled: false,
      height: 32,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.blueGrey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  PopupMenuItem<TablePinPosition> _buildPopupItem({
    required TablePinPosition value,
    required IconData icon,
    required String label,
    required TextStyle style,
  }) {
    return PopupMenuItem<TablePinPosition>(
      value: value,
      height: 48,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.blueGrey.shade600),
          ),
          const SizedBox(width: 14),
          Text(label, style: style),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isPinned = widget.pinnedPosition != TablePinPosition.none;

    return Stack(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onSecondaryTapDown: (details) =>
                _showContextMenu(context, details.globalPosition),
            child: InkWell(
              onTap: widget.onTap,
              child: Container(
                color: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Align(
                  alignment: widget.column.alignment,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          widget.column.title,
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
                      if (widget.isSort)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Icon(
                            widget.ascending
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            size: 16,
                            color: primaryColor.withAlpha(120),
                          ),
                        ),
                      if (widget.onPinnedPositionChanged != null && isPinned)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.onPinnedPositionChanged!(
                                TablePinPosition.none,
                              ),
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                child: Icon(
                                  Icons.push_pin,
                                  size: 14,
                                  color: primaryColor.withAlpha(180),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (widget.onPinnedPositionChanged != null &&
                          !isPinned &&
                          _isHovered)

                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => widget.onPinnedPositionChanged!(
                                TablePinPosition.left,
                              ),
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                child: Icon(
                                  Icons.push_pin_outlined,
                                  size: 14,
                                  color: primaryColor.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Resize Handle
        if (widget.onResizing != null)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                widget.onResizing!(details.delta.dx);
              },
              onHorizontalDragEnd: (_) {
                widget.onResizeEnd?.call();
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


