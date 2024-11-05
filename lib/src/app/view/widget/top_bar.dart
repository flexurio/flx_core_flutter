import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flexurio_erp_core/src/app/bloc/theme/menu_collapse/menu_collapse.dart';
import 'package:flexurio_erp_core/src/app/bloc/theme/theme_bloc.dart';
import 'package:flexurio_erp_core/src/app/view/widget/search_box/search_data.dart';
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
    required this.drawerTriggered,
    required this.onChangePassword,
    required this.searchData,
    super.key,
  });

  final List<SearchData> searchData;
  final String accountName;
  final String accountSubtitle;
  final List<Menu1> menu;
  final List<String> accountPermission;
  final void Function() onLogout;
  final void Function() drawerTriggered;
  final void Function(BuildContext context) onChangePassword;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScreenIdentifierBuilder(
      builder: (context, screenIdentifier) {
        return screenIdentifier.conditions(
          md: _buildLargeTopBar(theme),
          sm: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                IconButton(
                  onPressed: drawerTriggered,
                  icon: const Icon(Icons.menu),
                ),
                const Gap(6),
                Image.asset(
                  'asset/image/logo-name-company-${flavorConfig.companyId}.png',
                  height: 40,
                ),
                const Spacer(),
                AccountButton(
                  onChangePassword: onChangePassword,
                  title: accountName,
                  subtitle: accountSubtitle,
                  onLogout: onLogout,
                ),
                // const Gap(24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLargeTopBar(ThemeData theme) {
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
            const SizedBox(width: 24),
            ScreenIdentifierBuilder(
              builder: (context, screenIdentifier) {
                return screenIdentifier.conditions(
                  md: _buildAccountButton(),
                  lg: Row(
                    children: [
                      _buildThemeLanguage(),
                      const Gap(24),
                      _buildAccountButton(),
                    ],
                  ),
                  xl: Row(
                    children: [
                      _buildAvatarNameEmail(),
                      _buildThemeLanguage(),
                      const Gap(24),
                      _buildLogoutButton(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  AccountButton _buildAccountButton() {
    return AccountButton(
      onChangePassword: onChangePassword,
      padding: 0,
      title: accountName,
      subtitle: accountSubtitle,
      onLogout: onLogout,
    );
  }

  _RoundedContainer _buildThemeLanguage() {
    return const _RoundedContainer(
      child: Row(
        children: [
          SwitchLightDarkMode(),
          Gap(24),
          SwitchLanguage(),
          Gap(6),
        ],
      ),
    );
  }

  SizedBox _buildAvatarNameEmail() {
    return SizedBox(
      width: 300,
      child: AvatarNameEmail(
        isOnPop: false,
        onLogout: onLogout,
        onChangePassword: onChangePassword,
        avatarWidth: 50,
        title: accountName,
        subtitle: accountSubtitle,
      ),
    );
  }

  _RoundedContainer _buildLogoutButton() {
    return _RoundedContainer(child: LogOutButton(onLogout: onLogout));
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
