import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:gap/gap.dart';

class BackButtonTitled extends StatelessWidget {
  const BackButtonTitled({
    required this.title,
    super.key,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            const Icon(FontAwesomeIcons.chevronLeft),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 25)),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button._({
    required this.action,
    required this.permission,
    this.onPressed,
    this.color,
    this.isInProgress = false,
    this.isSecondary = false,
    this.rounded = false,
    this.entity,
  }) : padding = null;

  Button.small({
    required this.permission,
    required DataAction action,
    super.key,
    this.color,
    this.onPressed,
    this.isInProgress = false,
    this.isSecondary = false,
    this.rounded = false,
    this.entity,
  })  : padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        action = action.title;

  factory Button.action({
    required DataAction action,
    required String? permission,
    void Function()? onPressed,
    bool isInProgress = false,
    bool isSecondary = false,
    Color? color,
    bool rounded = false,
    Entity? entity,
  }) {
    return Button._(
      permission: permission,
      color: color,
      onPressed: onPressed,
      action: action.title,
      isInProgress: isInProgress,
      isSecondary: isSecondary,
      rounded: rounded,
      entity: entity,
    );
  }

  factory Button.string({
    required String action,
    required bool isInProgress,
    required String? permission, bool isSecondary = false,
    Color? color,
    void Function()? onPressed,
    bool rounded = false,
    Entity? entity,
  }) {
    return Button._(
      permission: permission,
      color: color,
      onPressed: onPressed,
      action: action,
      isInProgress: isInProgress,
      isSecondary: isSecondary,
      rounded: rounded,
      entity: entity,
    );
  }

  final String? permission;
  final Color? color;
  final void Function()? onPressed;
  final String action;
  final bool isInProgress;
  final bool isSecondary;
  final EdgeInsetsGeometry? padding;
  final bool rounded;
  final Entity? entity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final buttonStyle = ButtonStyle(
      padding: WidgetStateProperty.all(
        isPlatformMobile()
            ? const EdgeInsets.symmetric(vertical: 6, horizontal: 24)
            : padding,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rounded ? 100 : 8),
        ),
      ),
      backgroundColor: WidgetStateProperty.all(
        isInProgress
            ? theme.modeCondition(Colors.grey.shade400, Colors.white12)
            : (isSecondary
                ? Colors.transparent
                : (onPressed == null
                    ? theme.modeCondition(Colors.grey.shade400, Colors.white12)
                    : color ?? primaryColor)),
      ),
      foregroundColor: WidgetStateProperty.all(
        color == Colors.white || isSecondary
            ? (isSecondary ? (color ?? Colors.grey[600]) : Colors.grey[600])
            : theme.modeCondition(
                Colors.white,
                onPressed == null ? Colors.white12 : Colors.white,
              ),
      ),
    );

    var title = action;
    if (entity != null) {
      title = '$action ${entity!.title}';
    }

    return VisibilityPermission(
      permission: permission == null ? null : [permission!],
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: !isInProgress ? onPressed : null,
        child: isInProgress
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(title),
      ),
    );
  }
}

class FabMini extends StatelessWidget {
  const FabMini({
    required this.action,
    required this.onPressed,
    super.key,
  });
  final void Function() onPressed;

  final DataAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return FloatingActionButton(
      backgroundColor: primaryColor,
      mini: true,
      onPressed: onPressed,
      child: IconTheme(
        data: const IconThemeData(size: 16, color: Colors.white),
        child: Icon(action.icon),
      ),
    );
  }
}

bool isPlatformMobile() => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

class IconButtonSmall extends StatelessWidget {
  const IconButtonSmall({
    required this.onPressed,
    required this.action,
    required this.permission,
    this.tooltipMessage,
    super.key,
  });
  final void Function()? onPressed;
  final DataAction action;
  final String? permission;
  final String? tooltipMessage;

  @override
  Widget build(BuildContext context) {
    return VisibilityPermission(
      permission: permission == null ? null : [permission!],
      child: Tooltip(
        message: tooltipMessage ?? action.title,
        child: TextButton(
          style: ButtonStyle(
            iconColor: WidgetStateProperty.all(action.color),
            overlayColor: WidgetStateProperty.all(action.color.withOpacity(.1)),
          ),
          onPressed: onPressed,
          child: Icon(action.icon),
        ),
      ),
    );
  }
}

class LightButton extends StatelessWidget {
  const LightButton({
    required this.action,
    required this.permission,
    this.entity,
    super.key,
    this.onPressed,
    this.title,
    this.isInProgress = false,
  });
  final void Function()? onPressed;

  final String? permission;
  final DataAction action;
  final EntityY? entity;
  final String? title;
  final bool isInProgress;

  @override
  Widget build(BuildContext context) {
    final noAction = onPressed == null;
    final theme = Theme.of(context);
    final foregroundColor =
        theme.modeCondition(Colors.blueGrey.shade700, Colors.white70);
    var titleX = action.title;
    if (title != null) {
      titleX += ' $title';
    } else if (entity != null) {
      titleX += ' ${entity!.title}';
    }

    return VisibilityPermission(
      permission: permission == null ? null : [permission!],
      child: ElevatedButton(
        style: ButtonStyle(
          overlayColor: WidgetStatePropertyAll(
            action.color.withOpacity(theme.modeCondition(.08, .03)),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12),
          ),
          shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(.3)),
          side: noAction
              ? null
              : WidgetStateProperty.all(
                  BorderSide(
                    color: theme.modeCondition(
                      Colors.grey.shade300,
                      MyTheme.black16dp,
                    ),
                  ),
                ),
          backgroundColor: WidgetStateProperty.all(
            noAction
                ? theme.modeCondition(Colors.white, MyTheme.black04dp)
                : Colors.transparent,
          ),
          foregroundColor: WidgetStateProperty.all(
            noAction
                ? theme.modeCondition(Colors.grey, Colors.white10)
                : foregroundColor,
          ),
        ),
        onPressed: isInProgress ? null : onPressed,
        child: Row(
          children: [
            IconTheme(
              data: const IconThemeData(size: 18),
              child: isInProgress
                  ? const CupertinoActivityIndicator()
                  : Icon(
                      action.icon,
                      color: noAction
                          ? theme.modeCondition(Colors.grey, Colors.white10)
                          : action.color,
                    ),
            ),
            const Gap(6),
            Text(titleX),
          ],
        ),
      ),
    );
  }
}

class LightButtonSmall extends StatelessWidget {
  const LightButtonSmall({
    required this.action,
    required this.permissions,
    this.entity,
    super.key,
    this.onPressed,
    this.status,
    this.title,
  });
  final void Function()? onPressed;

  final DataAction action;
  final Entity? entity;
  final List<String>? permissions;
  final Status? status;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final noAction = onPressed == null;
    final theme = Theme.of(context);

    late Color badgeColor;
    if (status == Status.loaded) {
      badgeColor = Colors.green;
    } else if (status == Status.error) {
      badgeColor = Colors.red;
    } else {
      badgeColor = Colors.transparent;
    }

    final isProgress = status == Status.progress;

    final foregroundColor =
        isProgress ? Colors.blueGrey.shade200 : _foregroundColor(theme);

    return VisibilityPermissionBuilder(
      permission: permissions,
      builder: (hasPermission) {
        return Tooltip(
          message: !hasPermission ? 'No permission' : action.title,
          child: Opacity(
            opacity: hasPermission ? 1 : .5,
            child: Badge(
              backgroundColor: badgeColor,
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  ),
                  shadowColor:
                      WidgetStateProperty.all(Colors.black.withOpacity(.3)),
                  backgroundColor: WidgetStateProperty.all(
                    noAction ? Colors.grey.shade100 : Colors.transparent,
                  ),
                  foregroundColor: WidgetStateProperty.all(foregroundColor),
                ),
                onPressed: !isProgress && hasPermission ? onPressed : null,
                child: Row(
                  children: [
                    if (status != null && status == Status.progress)
                      const CupertinoActivityIndicator()
                    else
                      IconTheme(
                        data: IconThemeData(
                          size: 18,
                          color: foregroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Icon(action.icon),
                        ),
                      ),
                    const Gap(6),
                    Text(
                      '${action.title} ${entity?.title ?? title ?? ''}'.trim(),
                      style: TextStyle(color: foregroundColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LBS_JANGAN_PAKE_INI_LAGI extends StatelessWidget {
  const LBS_JANGAN_PAKE_INI_LAGI({
    required this.action,
    required this.permission,
    this.entity,
    super.key,
    this.onPressed,
    this.status,
    this.title,
  });
  final void Function()? onPressed;

  final DataAction action;
  final Entity? entity;
  final String? permission;
  final Status? status;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final noAction = onPressed == null;
    final theme = Theme.of(context);

    late Color badgeColor;
    if (status == Status.loaded) {
      badgeColor = Colors.green;
    } else if (status == Status.error) {
      badgeColor = Colors.red;
    } else {
      badgeColor = Colors.transparent;
    }

    final isProgress = status == Status.progress;

    final foregroundColor =
        isProgress ? Colors.blueGrey.shade200 : _foregroundColor(theme);

    return VisibilityPermission(
      permission: permission == null ? null : [permission!],
      child: Badge(
        backgroundColor: badgeColor,
        child: ElevatedButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(.3)),
            backgroundColor: WidgetStateProperty.all(
              noAction ? Colors.grey.shade100 : Colors.transparent,
            ),
            foregroundColor: WidgetStateProperty.all(foregroundColor),
          ),
          onPressed: !isProgress ? onPressed : null,
          child: Row(
            children: [
              if (status != null && status == Status.progress)
                const CupertinoActivityIndicator()
              else
                IconTheme(
                  data: IconThemeData(
                    size: 18,
                    color: foregroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Icon(action.icon),
                  ),
                ),
              const Gap(6),
              Text(
                '${action.title} ${entity?.title ?? title ?? ''}'.trim(),
                style: TextStyle(color: foregroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropDownSmallButton extends StatelessWidget {
  const DropDownSmallButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });
  final void Function() onPressed;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = _foregroundColor(theme);
    return ElevatedButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
        side: WidgetStateProperty.all(
          BorderSide(
            color: theme.modeCondition(
              Colors.grey.shade400.withOpacity(.7),
              MyTheme.black16dp,
            ),
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(.3)),
        backgroundColor: WidgetStateProperty.all(theme.cardColor),
        foregroundColor: WidgetStateProperty.all(foregroundColor),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(icon, size: 16),
            ),
          const Gap(12),
          Text(label),
          const Gap(6),
          IconTheme(
            data: IconThemeData(
              size: 18,
              color: foregroundColor,
            ),
            child: const Icon(Icons.keyboard_arrow_down_rounded),
          ),
        ],
      ),
    );
  }
}

Color _foregroundColor(ThemeData theme) {
  return theme.modeCondition(
    Colors.blueGrey.shade700,
    Colors.blueGrey.shade200,
  );
}

class BackButtonWithTitle extends StatelessWidget {
  const BackButtonWithTitle({
    required this.title,
    super.key,
    this.visibleBackButton = true,
  });

  final String title;
  final bool visibleBackButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
    final foregroundColor = theme.textTheme.bodyMedium!.color!;
    if (visibleBackButton) {
      return Row(
        children: [
          BackButton(
            style: ButtonStyle(
              foregroundColor:
                  WidgetStatePropertyAll(foregroundColor.withAlpha(170)),
              side: WidgetStateProperty.all(
                BorderSide(color: foregroundColor.withAlpha(50)),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Gap(12),
          text,
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: text,
    );
  }
}
