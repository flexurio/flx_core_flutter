import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flexurio_erp_core/src/app/bloc/theme/menu_collapse/menu_collapse.dart';
import 'package:flexurio_erp_core/src/app/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:screen_identifier/screen_identifier.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    required this.accountName,
    required this.accountSubtitle,
    required this.menu,
    required this.accountPermission,
    required this.onLogout,
    super.key,
  });

  final String accountName;
  final String accountSubtitle;
  final List<Menu1> menu;
  final List<String> accountPermission;
  final void Function() onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 80,
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: paddingHorizontalPage,
          vertical: 12,
        ),
        child: Row(
          children: [
            BlocBuilder<MenuCollapseBloc, bool>(
              builder: (context, state) {
                return SizedBox(
                  width: state ? sideNavWidthCollapsed : sideNavWidth,
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'today'.tr(),
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  DateFormat('E, MMM d, yyyy').format(DateTime.now()),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const Gap(24),
            Expanded(
              child: SearchBoxLarge(
                menu: menu,
                permissions: accountPermission,
              ),
            ),
            const SizedBox(width: 48),
            ScreenIdentifierBuilder(
              builder: (context, screenIdentifier) {
                return screenIdentifier.conditions(
                  lg: AccountButton(
                    padding: 0,
                    title: accountName,
                    subtitle: accountSubtitle,
                    onLogout: onLogout,
                  ),
                  xl: _Profile(
                    title: accountName,
                    subtitle: accountSubtitle,
                    onLogout: onLogout,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile({
    required this.title,
    required this.subtitle,
    required this.onLogout,
  });

  final String title;
  final String subtitle;
  final void Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: AvatarNameEmail(
            avatarWidth: 50,
            title: title,
            subtitle: subtitle,
          ),
        ),
        const _RoundedContainer(
          child: Row(
            children: [
              SwitchLightDarkMode(),
              Gap(24),
              SwitchLanguage(),
              Gap(6),
            ],
          ),
        ),
        const Gap(24),
        _RoundedContainer(
          child: LogOutButton(
            onLogout: onLogout,
          ),
        ),
      ],
    );
  }
}

class SwitchLightDarkMode extends StatelessWidget {
  const SwitchLightDarkMode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ThemeBloc, ThemeMode>(
      bloc: ThemeBloc.instance,
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            ThemeBloc.instance.add(
              state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
            );
          },
          icon: Icon(
            state == ThemeMode.light ? Icons.light_mode : Icons.dark_mode,
            color: theme.modeCondition(
              Colors.orange.shade700,
              Colors.blue.shade100,
            ),
          ),
        );
      },
    );
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    required this.onLogout,
    super.key,
  });

  final void Function() onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      tooltip: 'logout'.tr(),
      color: theme.isDark ? Colors.white70 : Colors.black54,
      onPressed: () {
        showDialogLogout(context: context, onLogout: onLogout);
      },
      icon: const Icon(Icons.exit_to_app),
    );
  }
}

class _RoundedContainer extends StatelessWidget {
  const _RoundedContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor.darken(.03),
        borderRadius: BorderRadius.circular(28),
      ),
      child: child,
    );
  }
}
