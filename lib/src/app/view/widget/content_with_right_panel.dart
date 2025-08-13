import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:hive/hive.dart';

class ContentWithRightPanel extends StatefulWidget {
  const ContentWithRightPanel({
    required this.child,
    required this.rightPanel,
    this.sideWidth = 380.0,
    super.key,
  });

  final Widget child;
  final Widget rightPanel;
  final double sideWidth;

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
    final sideWidth = widget.sideWidth;
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
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: theme.modeCondition(
                  const [
                    Color(0xFFF1F4F8),
                    Color(0xFFE3E8F8),
                  ],
                  [const Color(0xff16171C), const Color(0xff16171C)],
                ),
              ),
              // color: theme.modeCondition(
              //   Color(0xFFF5F7FB),
              //   const Color(0xff16171C),
              // ),
            ),
            width: sideWidth,
            child: ClipRRect(
              child: widget.rightPanel,
            ),
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
