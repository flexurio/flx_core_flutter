import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/util/color.dart';
import 'package:flx_core_flutter/src/app/util/theme.dart';

class YuhuTableStyle {
  final ThemeData theme;
  final BuildContext context;
  final Color? customHeaderColor;
  final Color? customStripedColor;

  YuhuTableStyle(
    this.context, {
    this.customHeaderColor,
    this.customStripedColor,
  }) : theme = Theme.of(context);

  BorderSide get borderSide => BorderSide(
        color: theme.dividerColor.withValues(alpha: 1),
      );

  BoxDecoration get headerDecoration => BoxDecoration(
        color: customHeaderColor ??
            (theme.brightness == Brightness.dark
                ? theme.colorScheme.primary.withValues(alpha: .15)
                : theme.colorScheme.primary.withValues(alpha: .08)),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: .2),
            width: 1.5,
          ),
        ),
      );

  Color get hoverColor {
    final primary = theme.colorScheme.primary;
    return theme.modeCondition(
      primary.withValues(alpha: .08),
      primary.withValues(alpha: .15),
    );
  }

  Color get stripedColor {
    return customStripedColor ??
        (theme.brightness == Brightness.dark
            ? theme.cardColor.lighten(.02)
            : const Color(0xFFF9FAFB));
  }

  BoxDecoration get containerDecoration => BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderSide.color, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      );
}
