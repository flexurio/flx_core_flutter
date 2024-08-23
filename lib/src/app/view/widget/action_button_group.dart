import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ActionButtonGroup extends StatelessWidget {
  const ActionButtonGroup({
    required this.action,
    required this.children,
    super.key,
  });

  final DataAction action;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return LightButtonSmall(
          action: action,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          permission: null,
        );
      },
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(theme.cardColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      menuChildren: children,
    );
  }
}
