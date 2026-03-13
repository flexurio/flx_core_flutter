import 'package:flutter/material.dart';
import 'package:flx_core_flutter/src/app/util/color.dart';
import 'package:flx_core_flutter/src/app/util/theme.dart';

class YuhuTableStyle {
  final ThemeData theme;
  final BuildContext context;

  YuhuTableStyle(this.context) : theme = Theme.of(context);

  BorderSide get borderSide => BorderSide(
        color: theme.dividerColor.withValues(alpha: 1),
      );

  BoxDecoration get headerDecoration => BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF1E293B) // Slate navy for dark mode header
            : const Color(0xFFF1F5F9), // Soft grey-blue for light mode
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
    return theme.brightness == Brightness.dark
        ? theme.cardColor.lighten(.02)
        : const Color(0xFFF9FAFB);
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
