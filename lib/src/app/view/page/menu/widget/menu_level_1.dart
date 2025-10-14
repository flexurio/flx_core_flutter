import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/view/page/menu/widget/menu_level_2.dart';
import 'package:gap/gap.dart';

class MenuLevel1 extends StatelessWidget {
  const MenuLevel1({
    required this.menu1,
    required this.index,
    required this.isCollapsed,
    required this.accountPermissions,
    required this.bypassPermission,
    super.key,
  });

  final Menu1 menu1;
  final int index;
  final bool isCollapsed;
  final List<String> accountPermissions;
  final bool bypassPermission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return BlocBuilder<MenuBloc, MenuState>(
      bloc: MenuBloc.instance,
      builder: (context, state) {
        var isEmpty = true;
        final children = <ExpansionPanel>[];

        for (var panelIndex = 0; panelIndex < menu1.menu.length; panelIndex++) {
          final menu2 = menu1.menu[panelIndex];
          final menuKey = '${menu1.label}#${menu1.menu[panelIndex].label}';
          final child = buildMenuLevel2(
            bypassPermission: bypassPermission,
            menu2: menu2,
            isExpanded: menuKey == state.menu2Expanded,
            isCollapsed: isCollapsed,
            accountPermissions: accountPermissions,
          );
          if (child != null) {
            isEmpty = false;
            children.add(child);
          }
        }

        if (isEmpty) return Container();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (menu1.label != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    height: 30,
                    child: Align(
                      alignment:
                          isCollapsed ? Alignment.center : Alignment.centerLeft,
                      child: isCollapsed
                          ? Icon(Icons.more_horiz, color: primaryColor)
                          : Text(
                              menu1.label!.tr().toUpperCase(),
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                    ),
                  ),
                ),
              if (isCollapsed)
                Column(
                  children: List.generate(
                    menu1.menu.length,
                    (index) => SizedBox(
                      height: 50,
                      child: Center(
                        child: Column(
                          children: [
                            FaIcon(menu1.menu[index].icon, size: 15),
                            const Gap(3),
                            Text(
                              menu1.menu[index].labelShort ??
                                  menu1.menu[index].label.tr(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                ExpansionPanelList(
                  elevation: 0,
                  dividerColor: Colors.transparent,
                  expandedHeaderPadding: EdgeInsets.zero,
                  expansionCallback: (panelIndex, isExpanded) {
                    final menuKey =
                        '${menu1.label}#${menu1.menu[panelIndex].label}';
                    MenuBloc.instance.add(
                      Menu2Expanded(
                        !isExpanded ? '' : menuKey,
                      ),
                    );
                  },
                  children: children,
                ),
            ],
          ),
        );
      },
    );
  }
}
