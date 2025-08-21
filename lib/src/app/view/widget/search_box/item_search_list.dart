import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/util/fuzzy.dart';
import 'package:flx_core_flutter/src/app/view/widget/search_box/menu_tile.dart';

class ItemSearchList extends StatefulWidget {
  const ItemSearchList({
    required this.query,
    required this.onTap,
    required this.menu,
    required this.permissions,
    required this.searchData,
    super.key,
  });
  final String query;
  final void Function(Menu3, String) onTap;
  final List<Menu1> menu;
  final List<String> permissions;
  final List<Widget> Function(BuildContext context, String query) searchData;

  @override
  State<ItemSearchList> createState() => _ItemSearchListState();
}

class _ItemSearchListState extends State<ItemSearchList> {
  late List<Widget> menuList;
  final _selectedItemIndex = 0;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    menuList = _menuSearch();
    if (widget.query.length > 2) {
      for (final element in widget.searchData(context, widget.query)) {
        menuList.add(element);
      }
    }
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  List<Widget> _menuSearch() {
    final menuList = <Widget>[];
    for (final menu in widget.menu) {
      final menu1 = menu.label;

      for (final menu in menu.menu) {
        final menu2 = menu.label;
        final icon = menu.icon;

        for (final menu3 in menu.menu) {
          final key = menu3.label.tr().toLowerCase();

          if ((menu3.permission == null ||
                  widget.permissions.contains(menu3.permission)) &&
              fuzzyMatch(widget.query, key)) {
            menuList.add(
              ItemList(
                onTap: () => widget.onTap(menu3, menu2),
                group:
                    '${menu1 == null ? '' : '${menu1.tr()} / '}${menu2.tr()}',
                query: widget.query,
                title: menu3.label.tr(),
                icon: Icon(icon),
              ),
            );
          }
        }
      }
    }

    return menuList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: menuList,
    );
    // return KeyboardListener(
    //   focusNode: _focusNode,
    //   child: ListView(
    //     children: menuList,
    //   ),
    // );
  }
}
