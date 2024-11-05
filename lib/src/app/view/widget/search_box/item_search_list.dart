import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flexurio_erp_core/src/app/util/fuzzy.dart';
import 'package:flexurio_erp_core/src/app/view/widget/search_box/menu_tile.dart';
import 'package:flutter/material.dart';

class ItemSearchList extends StatelessWidget {
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

  List<Widget> _menuSearch() {
    final menuList = <Widget>[];
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
              ItemList(
                onTap: () => onTap(menu3, menu2),
                group:
                    '${menu1 == null ? '' : '${menu1.tr()} / '}${menu2.tr()}',
                query: query,
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
    final menuList = List<Widget>.from(_menuSearch());
    if (query.length > 2) {
      for (final element in searchData(context, query)) {
        menuList.add(element);
      }
    }
    return ListView(children: menuList);
  }
}
