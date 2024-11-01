import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flexurio_erp_core/src/app/bloc/theme/menu_collapse/menu_collapse.dart';
import 'package:flexurio_erp_core/src/app/view/page/menu/widget/menu_level_1.dart';
import 'package:flexurio_erp_core/src/app/view/page/menu/widget/toggle_side_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:screen_identifier/screen_identifier.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class MenuSideNav extends StatefulWidget {
  const MenuSideNav({
    required this.menu,
    required this.accountPermission,
    this.noCollapse = false,
    this.drawerTriggered,
    super.key,
  });
  final List<Menu1> menu;
  final List<String> accountPermission;
  final bool noCollapse;
  final void Function()? drawerTriggered;

  @override
  State<MenuSideNav> createState() => _MenuSideNavState();
}

class _MenuSideNavState extends State<MenuSideNav> {
  bool _hovered = false;
  bool _hasMouse = false;
  final _scrollController = ScrollController();

  T _conditionCollapsed<T>(
    bool stateCollapsed, {
    required T collapsed,
    required T unCollapsed,
  }) {
    return _hovered ? unCollapsed : (stateCollapsed ? collapsed : unCollapsed);
  }

  @override
  Widget build(BuildContext context) {
    final menuFiltered = filterMenuByPermission(
      menu: widget.menu,
      permissions: widget.accountPermission,
    );
    return GestureDetector(
      onTap: () {
        if (!_hasMouse) widget.drawerTriggered?.call();
      },
      child: MouseRegion(
        onEnter: (_) => setState(() {
          _hasMouse = true;
          _hovered = true;
        }),
        onExit: (_) => setState(() => _hovered = false),
        child: _buildSideNav(menuFiltered),
      ),
    );
  }

  Widget _buildSideNav(List<Menu1> menuFiltered) {
    return ScreenIdentifierBuilder(
      builder: (context, screenIdentifier) {
        final theme = Theme.of(context);
        return BlocBuilder<MenuCollapseBloc, bool>(
          builder: (context, collapsedX) {
            return ScreenIdentifierBuilder(
              builder: (context, screenIdentifier) {
                final collapsed = screenIdentifier.conditions(
                  md: collapsedX,
                  sm: true,
                );

                return Material(
                  color: theme.cardColor,
                  shadowColor: Colors.black,
                  elevation: collapsed && _hovered ? 8 : 0,
                  child: AnimatedContainer(
                    width: widget.noCollapse
                        ? sideNavWidth
                        : _conditionCollapsed<double>(
                            collapsed,
                            collapsed: sideNavWidthCollapsed,
                            unCollapsed: sideNavWidth,
                          ),
                    duration: const Duration(milliseconds: 200),
                    child: SafeArea(
                      child: Column(
                        children: [
                          const Gap(12),
                          ToggleSideNav(
                            noCollapse: widget.noCollapse,
                            isCollapsed: !widget.noCollapse &&
                                _conditionCollapsed<bool>(
                                  collapsed,
                                  collapsed: true,
                                  unCollapsed: false,
                                ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: _buildListMenu(menuFiltered, collapsed),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildListMenu(List<Menu1> menuFiltered, bool collapsed) {
    return WebSmoothScroll(
      controller: _scrollController,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: menuFiltered.length,
        itemBuilder: (context, index) {
          final menu1 = menuFiltered[index];
          return MenuLevel1(
            accountPermissions: widget.accountPermission,
            menu1: menu1,
            index: index,
            isCollapsed: !widget.noCollapse &&
                _conditionCollapsed<bool>(
                  collapsed,
                  collapsed: true,
                  unCollapsed: false,
                ),
          );
        },
      ),
    );
  }
}

List<Menu1> filterMenuByPermission({
  required List<Menu1> menu,
  required List<String> permissions,
}) {
  try {
    final menu1Filtered = <Menu1>[];
    for (final menu1 in menu) {
      final menu2Filtered = <Menu2>[];
      for (final menu2 in menu1.menu) {
        final menu3Filtered = <Menu3>[];
        for (final menu3 in menu2.menu) {
          if (menu3.permission == null ||
              permissions.contains(menu3.permission)) {
            menu3Filtered.add(menu3);
          }
        }
        if (menu3Filtered.isNotEmpty) {
          menu2Filtered.add(
            Menu2(
              icon: menu2.icon,
              menu: menu3Filtered,
              label: menu2.label,
            ),
          );
        }
      }
      if (menu2Filtered.isNotEmpty) {
        menu1Filtered.add(
          Menu1(
            menu: menu2Filtered,
            label: menu1.label,
          ),
        );
      }
    }
    return menu1Filtered;
  } catch (e, s) {
    print(s);
    return [];
  }
}
