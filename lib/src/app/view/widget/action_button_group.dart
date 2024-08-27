import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LightButtonSmallGroup extends StatefulWidget {
  const LightButtonSmallGroup({
    required this.action,
    required this.children,
    super.key,
  });

  final DataAction action;
  final Map<String?, Widget> children;

  @override
  State<LightButtonSmallGroup> createState() => _LightButtonSmallGroupState();
}

class _LightButtonSmallGroupState extends State<LightButtonSmallGroup> {
  List<String> permissions = [];

  @override
  void initState() {
    super.initState();
    () async {
      final userRepository = await Hive.openBox<dynamic>('user_repository');
      permissions = userRepository.get('permission') as List<String>;
      setState(() {});
    }();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final allFalse = widget.children.keys
        .map((e) => permissions.contains(e))
        .every((item) => !item);
    if (allFalse) {
      return const SizedBox();
    }

    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return LightButtonSmall(
          action: widget.action,
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
      menuChildren: widget.children.values.toList(),
    );
  }
}
