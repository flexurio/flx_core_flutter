import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/util/generate_hierarchy.dart';

/// A definition for a single column in the [HierarchyDynamicTable].
class DynamicTableColumn<T> {
  final String label;
  final double width;
  final bool isNumber;
  final bool isBold;
  final bool isLeftBorder;
  final Color? Function(T)? colorBuilder;
  final Widget Function(T, ThemeData) builder;

  const DynamicTableColumn({
    required this.label,
    required this.width,
    required this.builder,
    this.isNumber = false,
    this.isBold = false,
    this.isLeftBorder = false,
    this.colorBuilder,
  });

  /// Factory for a simple text-based value cell.
  factory DynamicTableColumn.text({
    required String label,
    required double width,
    required String Function(T) valueMapper,
    bool isNumber = false,
    bool isBold = false,
    bool isLeftBorder = false,
    Color? Function(T)? colorBuilder,
  }) {
    return DynamicTableColumn(
      label: label,
      width: width,
      isNumber: isNumber,
      isBold: isBold,
      isLeftBorder: isLeftBorder,
      colorBuilder: colorBuilder,
      builder: (item, theme) {
        final value = valueMapper(item);
        final color = colorBuilder?.call(item);
        return Container(
          width: width,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: isNumber ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              left: isLeftBorder
                  ? BorderSide(
                      color: theme.modeCondition(
                          Colors.grey.shade200, Colors.white12))
                  : BorderSide.none,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        );
      },
    );
  }
}

/// A definition for a group of columns (e.g., a Month with multiple sub-values).
class DynamicTableColumnGroup<T> {
  final String label;
  final List<DynamicTableColumn<T>> columns;
  final double width;

  const DynamicTableColumnGroup({
    required this.label,
    required this.columns,
    required this.width,
  });

  /// Static helper to generate 12 monthly groups easily.
  static List<DynamicTableColumnGroup<T>> generateMonths<T>({
    required List<DynamicTableColumn<T>> Function(String monthKey) builder,
    double groupWidth = 240,
  }) {
    const months = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december'
    ];
    return months
        .map((m) => DynamicTableColumnGroup<T>(
              label: m.tr(),
              width: groupWidth,
              columns: builder(m),
            ))
        .toList();
  }
}

/// A premium, highly customizable table widget that supports hierarchical data,
/// frozen columns, and flexible layouts.
class HierarchyDynamicTable<T, ID> extends StatefulWidget {
  final List<TreeItem<T>> tree;
  final Set<ID> parentVisibility;
  final void Function(ID) onToggleExpansion;
  final bool isSearching;
  final ID Function(T) idMapper;
  final int Function(T) levelMapper;

  // Frozen Column (Left)
  final String frozenHeaderLabel;
  final double frozenWidth;
  final Widget Function(T item, int depth, bool hasChildren, bool isExpanded,
      bool isLink, ThemeData theme) frozenCellBuilder;
  final void Function(T)? onRowTap;

  // Scrollable Columns
  final List<DynamicTableColumnGroup<T>> columnGroups;
  final ScrollController? scrollController;

  // Per-row actions (Right)
  final Widget Function(T, ThemeData)? rowActionBuilder;
  final double rowActionWidth;
  final bool freezeActionColumn;

  // Top Layout
  final Widget? filterWidget;
  final Widget? actionWidget;
  final Widget? searchWidget;

  // Tooltips
  final String? frozenHeaderTooltip;

  // Styling
  final double headerHeight;
  final double rowHeight;

  const HierarchyDynamicTable({
    super.key,
    required this.tree,
    required this.parentVisibility,
    required this.onToggleExpansion,
    required this.idMapper,
    required this.levelMapper,
    required this.frozenHeaderLabel,
    required this.frozenWidth,
    required this.frozenCellBuilder,
    required this.columnGroups,
    this.isSearching = false,
    this.onRowTap,
    this.scrollController,
    this.rowActionBuilder,
    this.rowActionWidth = 100,
    this.freezeActionColumn = true,
    this.filterWidget,
    this.actionWidget,
    this.searchWidget,
    this.frozenHeaderTooltip,
    this.headerHeight = 62,
    this.rowHeight = 48,
  });

  @override
  State<HierarchyDynamicTable<T, ID>> createState() =>
      _HierarchyDynamicTableState<T, ID>();
}

class _HierarchyDynamicTableState<T, ID>
    extends State<HierarchyDynamicTable<T, ID>> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Layout Row: Filter (Left) & Action (Right)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.filterWidget != null) widget.filterWidget!,
            if (widget.actionWidget != null) widget.actionWidget!,
          ],
        ),
        if (widget.searchWidget != null) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [widget.searchWidget!],
          ),
        ],
        const SizedBox(height: 40),

        // Main Table Container
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: theme.modeCondition(Colors.white, theme.cardColor),
            border: Border.all(
              color: theme.modeCondition(
                Colors.blueGrey.shade100.withOpacity(.5),
                Colors.black12,
              ),
            ),
            boxShadow: theme.modeCondition(
              [
                const BoxShadow(
                  color: Color(0x12020617),
                  offset: Offset(0, 10),
                  blurRadius: 30,
                ),
                const BoxShadow(
                  color: Color(0x08020617),
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
              [
                const BoxShadow(
                  color: Color(0x73000000),
                  offset: Offset(0, 12),
                  blurRadius: 32,
                ),
                const BoxShadow(
                  color: Color(0x26000000),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Frozen Column (Left)
                  _buildFrozenColumn(theme),

                  // 2. Scrollable Columns (Middle)
                  _buildScrollableArea(theme),

                  // 3. Frozen Action Column (Right) - Optional
                  if (widget.rowActionBuilder != null &&
                      widget.freezeActionColumn)
                    _buildFrozenActionColumn(theme),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFrozenColumn(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          height: widget.headerHeight,
          width: widget.frozenWidth,
          decoration: BoxDecoration(
            color: theme.modeCondition(Colors.grey.shade100, Colors.black12),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: widget.frozenHeaderTooltip != null
              ? Tooltip(
                  message: widget.frozenHeaderTooltip!,
                  child: Text(
                    widget.frozenHeaderLabel,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                )
              : Text(
                  widget.frozenHeaderLabel,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
        ),
        // Rows
        ...widget.tree.map((node) => _buildFrozenRowNode(node, 0, theme)),
      ],
    );
  }

  Widget _buildFrozenRowNode(TreeItem<T> node, int depth, ThemeData theme) {
    final item = node.item;
    final id = widget.idMapper(item);
    final isExpanded =
        widget.isSearching || widget.parentVisibility.contains(id);
    final hasChildren = node.children.isNotEmpty;

    return Column(
      children: [
        _buildFrozenRow(item, depth, hasChildren, isExpanded, theme),
        if (isExpanded)
          ...node.children
              .map((child) => _buildFrozenRowNode(child, depth + 1, theme)),
      ],
    );
  }

  Widget _buildFrozenRow(
      T item, int depth, bool hasChildren, bool isExpanded, ThemeData theme) {
    final isParent = widget.levelMapper(item) == 1;

    return InkWell(
      onTap: () {
        final id = widget.idMapper(item);
        if (hasChildren) {
          widget.onToggleExpansion(id);
        } else if (widget.onRowTap != null) {
          widget.onRowTap!(item);
        }
      },
      child: Container(
        width: widget.frozenWidth,
        height: widget.rowHeight,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color:
                    theme.modeCondition(Colors.grey.shade200, Colors.white10)),
          ),
          color: isParent
              ? theme.modeCondition(
                  Colors.grey.shade50, Colors.white.withOpacity(0.02))
              : null,
        ),
        child: widget.frozenCellBuilder(item, depth, hasChildren, isExpanded,
            !hasChildren && widget.onRowTap != null, theme),
      ),
    );
  }

  Widget _buildScrollableArea(ThemeData theme) {
    return Expanded(
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildScrollableHeader(theme),
              // Rows
              ...widget.tree
                  .map((node) => _buildScrollableRowNode(node, 0, theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableHeader(ThemeData theme) {
    return Container(
      height: widget.headerHeight,
      decoration: BoxDecoration(
        color: theme.modeCondition(Colors.grey.shade100, Colors.black12),
      ),
      child: Row(
        children: [
          ...widget.columnGroups
              .map((group) => _buildHeaderGroup(group, theme)),
          if (widget.rowActionBuilder != null && !widget.freezeActionColumn)
            _buildActionHeader(theme),
        ],
      ),
    );
  }

  Widget _buildHeaderGroup(DynamicTableColumnGroup<T> group, ThemeData theme) {
    return Container(
      width: group.width,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              color: theme.modeCondition(Colors.grey.shade300, Colors.white12)),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: widget.headerHeight / 2,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: theme.modeCondition(
                          Colors.grey.shade300, Colors.white12))),
            ),
            child: Text(
              group.label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Row(
            children: group.columns
                .map((col) => _buildSubHeader(col, theme))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeader(DynamicTableColumn<T> col, ThemeData theme) {
    return Container(
      width: col.width,
      height: widget.headerHeight / 2,
      alignment: col.isNumber ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          left: col.isLeftBorder
              ? BorderSide(
                  color:
                      theme.modeCondition(Colors.grey.shade200, Colors.white12))
              : BorderSide.none,
        ),
      ),
      child: Text(
        col.label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildActionHeader(ThemeData theme) {
    return Container(
      width: widget.rowActionWidth,
      height: widget.headerHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.modeCondition(Colors.grey.shade100, Colors.black12),
        border: Border(
          left: BorderSide(
              color: theme.modeCondition(Colors.grey.shade300, Colors.white12)),
        ),
      ),
      child: Text(
        'actions'.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _buildScrollableRowNode(TreeItem<T> node, int depth, ThemeData theme) {
    final item = node.item;
    final id = widget.idMapper(item);
    final isExpanded =
        widget.isSearching || widget.parentVisibility.contains(id);

    return Column(
      children: [
        _buildScrollableRow(item, theme),
        if (isExpanded)
          ...node.children
              .map((child) => _buildScrollableRowNode(child, depth + 1, theme)),
      ],
    );
  }

  Widget _buildScrollableRow(T item, ThemeData theme) {
    final isParent = widget.levelMapper(item) == 1;

    return Container(
      height: widget.rowHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: theme.modeCondition(Colors.grey.shade200, Colors.white10)),
        ),
        color: isParent
            ? theme.modeCondition(
                Colors.grey.shade50, Colors.white.withOpacity(0.02))
            : null,
      ),
      child: Row(
        children: [
          ...widget.columnGroups
              .map((group) => _buildRowGroup(item, group, theme)),
          if (widget.rowActionBuilder != null && !widget.freezeActionColumn)
            _buildActionCell(item, theme),
        ],
      ),
    );
  }

  Widget _buildRowGroup(
      T item, DynamicTableColumnGroup<T> group, ThemeData theme) {
    return Container(
      width: group.width,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              color: theme.modeCondition(Colors.grey.shade300, Colors.white12)),
        ),
      ),
      child: Row(
        children: group.columns.map((col) => col.builder(item, theme)).toList(),
      ),
    );
  }

  Widget _buildActionCell(T item, ThemeData theme) {
    return Container(
      width: widget.rowActionWidth,
      height: widget.rowHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              color: theme.modeCondition(Colors.grey.shade200, Colors.white12)),
        ),
      ),
      child: widget.rowActionBuilder!(item, theme),
    );
  }

  Widget _buildFrozenActionColumn(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActionHeader(theme),
        ...widget.tree.map((node) => _buildFrozenActionRowNode(node, 0, theme)),
      ],
    );
  }

  Widget _buildFrozenActionRowNode(
      TreeItem<T> node, int depth, ThemeData theme) {
    final item = node.item;
    final id = widget.idMapper(item);
    final isExpanded =
        widget.isSearching || widget.parentVisibility.contains(id);

    return Column(
      children: [
        _buildFrozenActionRow(item, theme),
        if (isExpanded)
          ...node.children.map(
              (child) => _buildFrozenActionRowNode(child, depth + 1, theme)),
      ],
    );
  }

  Widget _buildFrozenActionRow(T item, ThemeData theme) {
    final isParent = widget.levelMapper(item) == 1;

    return Container(
      width: widget.rowActionWidth,
      height: widget.rowHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: theme.modeCondition(Colors.grey.shade200, Colors.white10)),
          left: BorderSide(
              color: theme.modeCondition(Colors.grey.shade300, Colors.white12)),
        ),
        color: isParent
            ? theme.modeCondition(
                Colors.grey.shade50, Colors.white.withOpacity(0.02))
            : null,
      ),
      alignment: Alignment.center,
      child: widget.rowActionBuilder!(item, theme),
    );
  }
}
