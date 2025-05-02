import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';

class LightButtonSmallGroup extends StatefulWidget {
  const LightButtonSmallGroup({
    required this.action,
    this.children,
    this.childrenList,
    super.key,
  }) : assert(
          !((children != null && childrenList != null) ||
              (children == null && childrenList == null)),
          'children and childrenList are mutually exclusive',
        );

  final DataAction action;
  final Map<String?, Widget>? children;
  final List<Widget>? childrenList;

  @override
  State<LightButtonSmallGroup> createState() => _LightButtonSmallGroupState();
}

class _LightButtonSmallGroupState extends State<LightButtonSmallGroup> {
  List<String> permissions = [];

  @override
  void initState() {
    super.initState();
    if (widget.children != null) {
      () async {
        final userRepository = await Hive.openBox<dynamic>('user_repository');
        permissions = userRepository.get('permission') as List<String>;
        setState(() {});
      }();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final menuChildren = <Widget>[];

    if (widget.children != null) {
      final allFalse = widget.children!.keys
          .map((e) => permissions.contains(e))
          .every((item) => !item);

      if (allFalse) {
        return const SizedBox();
      }
      menuChildren.addAll(widget.children!.values.toList());
    } else {
      menuChildren.addAll(widget.childrenList!);
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
      menuChildren: menuChildren,
    );
  }
}

class ActionsButton extends StatefulWidget {
  const ActionsButton({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  State<ActionsButton> createState() => _ActionsButton();
}

class _ActionsButton extends State<ActionsButton> {
  final _controller = MenuController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return const SizedBox();
    }

    final theme = Theme.of(context);

    return MenuAnchor(
      controller: _controller,
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButtonSmall(
          action: DataAction.actions,
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
      menuChildren: widget.children
          .map(
            (e) => Listener(
              behavior: HitTestBehavior.translucent,
              child: e,
              onPointerUp: (event) {
                _controller.close();
              },
            ),
          )
          .toList(),
    );
  }
}

class ActionButtonX extends StatelessWidget {
  const ActionButtonX({required this.items, super.key});

  final List<ActionButtonItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SpeedDial(
      backgroundColor: Colors.blueGrey.shade400,
      foregroundColor: theme.canvasColor,
      icon: Icons.more_vert,
      overlayColor: Colors.black,
      overlayOpacity: .3,
      children: items
          .map(
            (e) => SpeedDialChild(
              foregroundColor: e.color,
              shape: const CircleBorder(),
              child: Icon(e.icon),
              label: e.label,
              onTap: e.onPressed,
            ),
          )
          .toList(),
    );
  }
}

class ActionButtonItem {
  ActionButtonItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
}
