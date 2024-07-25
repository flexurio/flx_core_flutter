import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flexurio_erp_core/src/app/view/page/menu/widget/menu_level_3.dart';
import 'package:flutter/material.dart';

ExpansionPanel? buildMenuLevel2({
  required Menu2 menu2,
  required bool isExpanded,
  required bool isCollapsed,
  required List<String> accountPermissions,
}) {
  var isEmpty = true;
  final children = <Widget>[];
  for (var index = 0; index < menu2.menu.length; index++) {
    final menu3 = menu2.menu[index];
    if (menu3.permission == null ||
        accountPermissions.contains(menu3.permission)) {
      isEmpty = false;
      children.add(MenuLevel3(isCollapsed: isCollapsed, menu3: menu3));
    }
  }

  if (isEmpty) {
    return null;
  }

  return ExpansionPanel(
    canTapOnHeader: true,
    isExpanded: isExpanded,
    headerBuilder: (context, isExpanded) {
      return Container(
        padding: const EdgeInsets.only(
          right: 6,
          left: 30,
          top: 15,
          bottom: 15,
        ),
        child: Row(
          children: [
            Flexible(
              child: SizedBox(
                width: 20,
                height: 20,
                child: Center(child: FaIcon(menu2.icon, size: 15)),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              menu2.label.tr(),
              maxLines: 1,
              style: TextStyle(
                fontWeight: isExpanded ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
      );
    },
    body: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
        const Positioned(left: 38, top: 0, bottom: 0, child: _VerticalLine()),
      ],
    ),
  );
}

class _VerticalLine extends StatelessWidget {
  const _VerticalLine();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.modeCondition(
          theme.colorScheme.primary.lighten(.33),
          theme.colorScheme.primary.darken(.1),
        ),
      ),
    );
  }
}
