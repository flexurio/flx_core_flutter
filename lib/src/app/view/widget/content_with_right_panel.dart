import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ContentWithRightPanel extends StatefulWidget {
  const ContentWithRightPanel({
    required this.child,
    required this.rightPanel,
    super.key,
  });

  final Widget child;
  final Widget rightPanel;

  @override
  State<ContentWithRightPanel> createState() => _ContentWithRightPanelState();
}

class _ContentWithRightPanelState extends State<ContentWithRightPanel> {
  bool _showSidePanel = true;
  late String key;
  Box<bool>? box;

  @override
  void initState() {
    super.initState();
    key = widget.key.toString();

    () async {
      box = await Hive.openBox<bool>('content_side_panel');
      _showSidePanel = box?.get(key, defaultValue: true)! ?? true;
      setState(() {});
    }();
  }

  void _toggle() {
    _showSidePanel = !_showSidePanel;
    box?.put(key, _showSidePanel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const sideWidth = 380.0;
    const duration = Duration(milliseconds: 200);
    return Stack(
      children: [
        AnimatedPositioned(
          left: 0,
          right: _showSidePanel ? sideWidth : 0,
          top: 0,
          bottom: 0,
          duration: duration,
          child: widget.child,
        ),
        AnimatedPositioned(
          right: _showSidePanel ? 0 : (sideWidth + 24) * -1,
          top: 0,
          bottom: 0,
          duration: duration,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(25),
              ),
              color: theme.modeCondition(
                Color(0XFFEFF0F6),
                const Color(0xff16171C),
              ),
            ),
            width: sideWidth,
            child: widget.rightPanel,
          ),
        ),
        AnimatedPositioned(
          top: 24,
          right: _showSidePanel ? sideWidth - 24 : 0,
          duration: duration,
          child: InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: _toggle,
            child: AnimatedContainer(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: theme.modeCondition(
                  Colors.blueGrey.shade100,
                  const Color.fromARGB(255, 32, 37, 48),
                ),
                borderRadius: BorderRadius.horizontal(
                  left:
                      !_showSidePanel ? const Radius.circular(16) : Radius.zero,
                  right:
                      _showSidePanel ? const Radius.circular(16) : Radius.zero,
                ),
              ),
              duration: duration,
              child: Icon(
                !_showSidePanel
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: theme.modeCondition(
                  Colors.grey.shade700,
                  Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
