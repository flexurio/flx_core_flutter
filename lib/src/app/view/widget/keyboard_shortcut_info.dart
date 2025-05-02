import 'package:easy_localization/easy_localization.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flutter/material.dart';

class KeyboardShortcutInfo extends StatelessWidget {
  const KeyboardShortcutInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Text(
          'keyboard_shortcuts'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 36),
        ShortcutInfo(
          title: 'search_dialog'.tr(),
          hotkey: const ['Shift', 'Alt', 'P'],
        ),
        ShortcutInfo(
          title: 'cache_refresh'.tr(),
          hotkey: const ['Ctrl', 'Shift', 'R'],
        ),
      ],
    );
  }
}

class ShortcutInfo extends StatelessWidget {
  const ShortcutInfo({
    required this.title,
    required this.hotkey,
    super.key,
  });
  final String title;
  final List<String> hotkey;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Expanded(child: Text(title)),
    ];

    for (final key in hotkey) {
      children.addAll([
        _ShortcutButton(key),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text('+'),
        ),
      ]);
    }

    if (hotkey.isNotEmpty) {
      children.removeLast();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: children,
      ),
    );
  }
}

class _ShortcutButton extends StatelessWidget {
  const _ShortcutButton(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: theme.modeCondition(
          primaryColor.lighten(.32),
          primaryColor.darken(.15),
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: theme.modeCondition(
              primaryColor.lighten(.27),
              primaryColor.darken(.2),
            ),
            offset: const Offset(3, 3),
          ),
        ],
        border: Border.all(
          color: theme.modeCondition(
            primaryColor.lighten(.27),
            primaryColor.darken(.2),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}
