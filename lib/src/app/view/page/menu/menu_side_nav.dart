import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/bloc/theme/menu_collapse/menu_collapse.dart';
import 'package:flx_core_flutter/src/app/view/page/menu/widget/menu_level_1.dart';
import 'package:gap/gap.dart';
import 'package:screen_identifier/screen_identifier.dart';

class MenuSideNav extends StatefulWidget {
  const MenuSideNav({
    required this.menu,
    required this.accountPermission,
    required this.logoUrl,
    required this.logoNamedUrl,
    this.noCollapse = false,
    this.drawerTriggered,
    super.key,
  });
  final List<Menu1> menu;
  final List<String> accountPermission;
  final bool noCollapse;
  final void Function()? drawerTriggered;
  final String? logoUrl;
  final String? logoNamedUrl;

  @override
  State<MenuSideNav> createState() => _MenuSideNavState();
}

class _MenuSideNavState extends State<MenuSideNav> {
  bool _hovered = false;
  bool _hasMouse = false;

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
                            logoNamedUrl: widget.logoNamedUrl,
                            logoUrl: widget.logoUrl,
                            noCollapse: widget.noCollapse,
                            isCollapsed: widget.noCollapse
                                ? false
                                : _conditionCollapsed<bool>(
                                    collapsed,
                                    collapsed: true,
                                    unCollapsed: false,
                                  ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: menuFiltered.length,
                              itemBuilder: (context, index) {
                                final menu1 = menuFiltered[index];
                                return MenuLevel1(
                                  accountPermissions: widget.accountPermission,
                                  menu1: menu1,
                                  index: index,
                                  isCollapsed: widget.noCollapse
                                      ? false
                                      : _conditionCollapsed<bool>(
                                          collapsed,
                                          collapsed: true,
                                          unCollapsed: false,
                                        ),
                                );
                              },
                            ),
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
}

class ToggleSideNav extends StatelessWidget {
  const ToggleSideNav({
    required this.isCollapsed,
    required this.noCollapse,
    required this.logoNamedUrl,
    required this.logoUrl,
    super.key,
  });

  final bool isCollapsed;
  final bool noCollapse;
  final String? logoUrl;
  final String? logoNamedUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ScreenIdentifierBuilder(
            builder: (context, screenIdentifier) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: isCollapsed
                    ? Logo(
                        logoUrl: logoUrl,
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: LogoNamed(
                              logoNamedUrl: logoNamedUrl,
                              logoUrl: logoUrl,
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 6,
                                bottom: 6,
                                top: 6,
                              ),
                            ),
                          ),
                          if (!noCollapse)
                            screenIdentifier.conditions(
                              md: const SizedBox(),
                              lg: const _ButtonToggle(),
                            ),
                        ],
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ButtonToggle extends StatelessWidget {
  const _ButtonToggle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<MenuCollapseBloc, bool>(
      builder: (context, collapsed) {
        final action = collapsed ? 'show' : 'hide';
        final hideIcon = SvgPicture.asset(
          'asset/svg/sidebar-$action.svg',
          height: 20,
          colorFilter: ColorFilter.mode(
            theme.modeCondition<Color>(
              theme.iconTheme.color!.lighten(0.45),
              theme.iconTheme.color!,
            ),
            BlendMode.srcATop,
          ),
        );
        return IconButton(
          tooltip: '${action}_sidebar'.tr(),
          onPressed: () {
            context.read<MenuCollapseBloc>().add(!collapsed);
          },
          icon: hideIcon,
        );
      },
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
  } catch (e) {
    return [];
  }
}
