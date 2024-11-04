import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flexurio_erp_core/src/app/bloc/theme/menu/menu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SearchBoxLarge extends StatelessWidget {
  const SearchBoxLarge({
    required this.menu,
    required this.permissions,
    super.key,
  });

  final List<Menu1> menu;
  final List<String> permissions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Material(
        color: Colors.black12,
        child: InkWell(
          onTap: () {
            showSearchDialog(
              context: context,
              menu: menu,
              accountPermissions: permissions,
            );
          },
          child: Container(
            height: 50,
            color: theme.scaffoldBackgroundColor.darken(.08),
            padding: const EdgeInsets.symmetric(
              horizontal: paddingHorizontalPage,
            ),
            child: Row(
              children: [
                const Icon(Icons.search),
                const Gap(12),
                Text('${'search'.tr()} ...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showSearchDialog({
  required BuildContext context,
  required List<Menu1> menu,
  required List<String> accountPermissions,
}) {
  final menuBloc = context.read<MenuBloc>();
  return showDialog<void>(
    context: context,
    builder: (context) {
      return _SearchDialog(
        menu: menu,
        permissions: accountPermissions,
        onTap: (menu, menu2) {
          menuBloc
            ..add(Menu2Expanded(menu2))
            ..add(
              Menu3Selected(
                home: menu.home,
                label: menu.label,
              ),
            );
          Navigator.pop(context);
        },
      );
    },
  );
}

class _SearchDialog extends StatefulWidget {
  const _SearchDialog({
    required this.onTap,
    required this.menu,
    required this.permissions,
  });
  final void Function(Menu3, String) onTap;
  final List<Menu1> menu;
  final List<String> permissions;

  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
            child: _MenuList(
              onTap: widget.onTap,
              query: _searchController.text,
              key: ValueKey(_searchController.text),
              menu: widget.menu,
              permissions: widget.permissions,
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

class _MenuList extends StatelessWidget {
  const _MenuList({
    required this.query,
    required this.onTap,
    required this.menu,
    required this.permissions,
    super.key,
  });
  final String query;
  final void Function(Menu3, String) onTap;
  final List<Menu1> menu;
  final List<String> permissions;

  @override
  Widget build(BuildContext context) {
    final menuList = <_MenuTile>[];
    var index = 0;
    for (final menu in menu) {
      final menu1 = menu.label;

      for (final menu in menu.menu) {
        final menu2 = menu.label;
        final icon = menu.icon;

        for (final menu3 in menu.menu) {
          final key = menu3.label.tr().toLowerCase();

          if ((menu3.permission == null ||
                  permissions.contains(menu3.permission)) &&
              fuzzyMatch(query, key)) {
            menuList.add(
              _MenuTile(
                query: query,
                onTap: onTap,
                index: index,
                menu: menu3,
                menu2: menu2,
                icon: Icon(icon),
                parent:
                    '${menu1 == null ? '' : '${menu1.tr()} / '}${menu2.tr()}',
              ),
            );
            index++;
          }
        }
      }
    }
    return ListView(children: menuList);
  }
}

bool fuzzyMatch(String query, String target) {
  if (query.isEmpty) {
    return true;
  }

  int queryIndex = 0;

  for (int i = 0; i < target.length; i++) {
    if (target[i].toLowerCase() == query[queryIndex].toLowerCase()) {
      queryIndex++;
      if (queryIndex == query.length) {
        return true;
      }
    }
  }

  return false;
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.menu,
    required this.menu2,
    required this.parent,
    required this.icon,
    required this.index,
    required this.onTap,
    required this.query,
  });
  final Menu3 menu;
  final String menu2;
  final String parent;
  final Icon icon;
  final int index;
  final String query;
  final void Function(Menu3 menu, String menu2) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme.bodyMedium!;
    Widget buildHighlightedText(String text, String query) {
      List<TextSpan> spans = [];
      int queryIndex = 0;

      for (int i = 0; i < text.length; i++) {
        if (queryIndex < query.length &&
            text[i].toLowerCase() == query[queryIndex].toLowerCase()) {
          spans.add(
            TextSpan(
              text: text[i],
              style: textTheme.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
          queryIndex++;
        } else {
          spans.add(
            TextSpan(
              text: text[i],
              style: textTheme,
            ),
          );
        }
      }

      return RichText(text: TextSpan(children: spans));
    }

    return InkWell(
      onTap: () => onTap(menu, menu2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 36),
        leading: IconTheme(
          data: IconThemeData(
            size: 14,
            color: theme.modeCondition(Colors.black54, Colors.white60),
          ),
          child: icon,
        ),
        title: Row(
          children: [
            buildHighlightedText(menu.label.tr(), query),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              width: 30,
              child: const Divider(),
            ),
            Text(
              parent,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              maxLines: 1,
            ),
          ],
        ),
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

class SearchIntent extends Intent {}

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    this.onChanged,
  });
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: '${'type_here_to_search'.tr()} ...',
          hintStyle: TextStyle(
            color: theme.textTheme.bodyMedium?.color
                ?.withOpacity(theme.modeCondition(.7, .3)),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
