import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/model/data_action.dart';
import 'package:flx_core_flutter/src/app/util/theme.dart';
import 'package:flx_core_flutter/src/app/view/widget/button.dart';
import 'package:gap/gap.dart';

/// A reusable dialog widget for selecting multiple items at once.
///
/// Designed to be flexible across all ERP modules (Sales Order, Purchase Order,
/// Inventory, Delivery Order, etc.) when users need to bulk-add items without
/// having to add them row-by-row.
class BulkItemSelectDialog<T> extends StatefulWidget {
  const BulkItemSelectDialog({
    required this.items,
    required this.itemTitle,
    this.title = 'Pilih Item',
    this.icon = Icons.playlist_add_check_rounded,
    this.itemSubtitle,
    this.itemTrailing,
    this.filter,
    this.searchHint = 'Cari berdasarkan nama atau kode...',
    this.confirmButtonTitle,
    this.preSelectedItems = const [],
    this.width = 720,
    this.maxHeight = 400,
    super.key,
  });

  /// The full list of available items to pick from.
  final List<T> items;

  /// Function that returns the primary display title for an item.
  final String Function(T item) itemTitle;

  /// Optional function that returns a subtitle (e.g. SKU, code, unit).
  final String Function(T item)? itemSubtitle;

  /// Optional function that returns a trailing widget (e.g. badge, price).
  final Widget Function(T item)? itemTrailing;

  /// Optional search filter function.
  /// If omitted, filters by [itemTitle] and [itemSubtitle].
  final bool Function(T item, String query)? filter;

  /// Dialog header title.
  final String title;

  /// Dialog icon.
  final IconData icon;

  /// Hint text for the search input.
  final String searchHint;

  /// Label for the confirmation action button.
  final String? confirmButtonTitle;

  /// List of items that should be initially selected.
  final List<T> preSelectedItems;

  /// Dialog width.
  final double width;

  /// Max height for the items scroll view.
  final double maxHeight;

  /// Helper static method to show the dialog and return selected items list.
  static Future<List<T>?> show<T>(
    BuildContext context, {
    required List<T> items,
    required String Function(T item) itemTitle,
    String title = 'Pilih Item',
    IconData icon = Icons.playlist_add_check_rounded,
    String Function(T item)? itemSubtitle,
    Widget Function(T item)? itemTrailing,
    bool Function(T item, String query)? filter,
    String searchHint = 'Cari berdasarkan nama atau kode...',
    String? confirmButtonTitle,
    List<T> preSelectedItems = const [],
    double width = 720,
    double maxHeight = 400,
  }) {
    return showDialog<List<T>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => BulkItemSelectDialog<T>(
        items: items,
        itemTitle: itemTitle,
        title: title,
        icon: icon,
        itemSubtitle: itemSubtitle,
        itemTrailing: itemTrailing,
        filter: filter,
        searchHint: searchHint,
        confirmButtonTitle: confirmButtonTitle,
        preSelectedItems: preSelectedItems,
        width: width,
        maxHeight: maxHeight,
      ),
    );
  }

  @override
  State<BulkItemSelectDialog<T>> createState() =>
      _BulkItemSelectDialogState<T>();
}

class _BulkItemSelectDialogState<T> extends State<BulkItemSelectDialog<T>> {
  final _searchController = TextEditingController();
  final Set<T> _selectedItems = <T>{};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll(widget.preSelectedItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<T> get _filteredItems {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.items;
    }

    if (widget.filter != null) {
      return widget.items.where((it) => widget.filter!(it, query)).toList();
    }

    return widget.items.where((it) {
      final title = widget.itemTitle(it).toLowerCase();
      final subtitle = widget.itemSubtitle?.call(it).toLowerCase() ?? '';
      return title.contains(query) || subtitle.contains(query);
    }).toList();
  }

  void _toggleSelectAll(List<T> currentFiltered) {
    setState(() {
      final allFilteredSelected =
          currentFiltered.every(_selectedItems.contains);
      if (allFilteredSelected) {
        // Deselect currently filtered items
        for (final it in currentFiltered) {
          _selectedItems.remove(it);
        }
      } else {
        // Select all currently filtered items
        _selectedItems.addAll(currentFiltered);
      }
    });
  }

  void _onConfirm() {
    Navigator.of(context).pop(_selectedItems.toList());
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(widget.icon, color: const Color(0XFFAFABBC)),
        const SizedBox(width: 8),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          icon: const Icon(Icons.close, color: Color(0XFFAFABBC)),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Close',
        ),
      ],
    );
  }

  Widget _buildActions(ThemeData theme, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.isDark ? MyTheme.black06dp : const Color(0XFFF8F7FB),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Button.string(
            permission: null,
            action: 'Batal',
            isInProgress: false,
            isSecondary: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Gap(8),
          Button.action(
            permission: null,
            action: DataAction.add,
            label: widget.confirmButtonTitle ??
                'Tambahkan ${count > 0 ? '($count Produk)' : ''}',
            onPressed: count > 0 ? _onConfirm : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredItems;
    final allFilteredSelected =
        filtered.isNotEmpty && filtered.every(_selectedItems.contains);
    final count = _selectedItems.length;

    final dialogWidth = widget.width > MediaQuery.of(context).size.width * 0.95
        ? MediaQuery.of(context).size.width * 0.95
        : widget.width;

    return Dialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SizedBox(
        width: dialogWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(context, theme),
                  const Gap(16),

                  // Search & Filter Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: widget.searchHint,
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              splashRadius: 16,
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Gap(12),

                  // Header action & summary row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: filtered.isEmpty
                            ? null
                            : () => _toggleSelectAll(filtered),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value:
                                    filtered.isNotEmpty && allFilteredSelected,
                                tristate:
                                    filtered.any(_selectedItems.contains) &&
                                        !allFilteredSelected,
                                onChanged: filtered.isEmpty
                                    ? null
                                    : (_) => _toggleSelectAll(filtered),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Text(
                                allFilteredSelected
                                    ? 'Batal Pilih Semua'
                                    : 'Pilih Semua',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$count item terpilih dari ${widget.items.length}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  const Divider(height: 1),
                  const Gap(8),

                  // List Items
                  SizedBox(
                    height: widget.maxHeight,
                    child: filtered.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 36),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 48,
                                    color:
                                        theme.hintColor.withValues(alpha: 0.5),
                                  ),
                                  const Gap(12),
                                  Text(
                                    'Tidak ada item yang ditemukan',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              indent: 48,
                            ),
                            itemBuilder: (context, index) {
                              final item = filtered[index];
                              final isSelected = _selectedItems.contains(item);
                              final title = widget.itemTitle(item);
                              final subtitle = widget.itemSubtitle?.call(item);
                              final trailing = widget.itemTrailing?.call(item);

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedItems.remove(item);
                                    } else {
                                      _selectedItems.add(item);
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                            .withValues(alpha: 0.05)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (val) {
                                          setState(() {
                                            if (val ?? false) {
                                              _selectedItems.add(item);
                                            } else {
                                              _selectedItems.remove(item);
                                            }
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                      const Gap(8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              title,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.w500,
                                              ),
                                            ),
                                            if (subtitle != null &&
                                                subtitle.isNotEmpty) ...[
                                              const Gap(2),
                                              Text(
                                                subtitle,
                                                style: theme
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: theme.hintColor,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (trailing != null) ...[
                                        const Gap(12),
                                        trailing,
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            _buildActions(theme, count),
          ],
        ),
      ),
    );
  }
}
