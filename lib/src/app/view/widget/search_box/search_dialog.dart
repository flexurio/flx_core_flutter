import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/view/widget/search_box/item_search_list.dart';
import 'package:gap/gap.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({
    required this.onTap,
    required this.menu,
    required this.permissions,
    required this.searchData,
    this.placeholderMenuList,
    super.key,
  });
  final void Function(Menu3, String) onTap;
  final List<Menu1> menu;
  final List<String> permissions;
  final List<Widget> Function(BuildContext context, String query) searchData;
  final Widget? placeholderMenuList;

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const maxWidth = 800;
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.cardColor,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        vertical: 90,
        horizontal: (size.width - maxWidth) / 2,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                const Gap(12),
                const Icon(Icons.search),
                const SizedBox(width: 18),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(
                      color: theme.modeCondition(null, Colors.white70),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '${'type_your_search_query_here'.tr()}...',
                      hintStyle: TextStyle(
                        color: theme.modeCondition(null, Colors.white24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _Tab(label: 'All', selected: true),
                Gap(3),
                _Tab(label: 'Menu', selected: false),
                Gap(3),
                _Tab(label: 'Ticket', selected: false),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ItemSearchList(
              onTap: widget.onTap,
              query: _searchController.text,
              key: ValueKey(_searchController.text),
              menu: widget.menu,
              permissions: widget.permissions,
              searchData: widget.searchData,
              placeholderMenuList: widget.placeholderMenuList,
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.grey),
              child: IconTheme(
                data: IconThemeData(size: 14, color: Colors.grey),
                child: Row(
                  children: [
                    Icon(Icons.north_rounded),
                    Icon(Icons.south_rounded),
                    Gap(12),
                    Text('Select'),
                    SizedBox(width: 36),
                    Icon(Icons.subdirectory_arrow_left_rounded),
                    Gap(12),
                    Text('Open'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.selected});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          const Gap(3),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            child: Text(
              label,
              style: TextStyle(fontWeight: selected ? FontWeight.bold : null),
            ),
          ),
          const Gap(3),
          Container(
            color: selected ? primaryColor : null,
            width: 34,
            height: 3,
          ),
        ],
      ),
    );
  }
}
