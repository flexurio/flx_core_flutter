import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flexurio_erp_core/src/app/bloc/theme/menu/menu_bloc.dart';
import 'package:flexurio_erp_core/src/app/bloc/theme/menu_collapse/menu_collapse.dart';
import 'package:flexurio_erp_core/src/app/view/page/menu/menu_side_nav.dart';
import 'package:flexurio_erp_core/src/app/view/page/menu/widget/menu_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:screen_identifier/screen_identifier.dart';

class MenuPage extends StatelessWidget {
  const MenuPage._(
    this.menu,
    this.accountPermissions,
    this.userName,
    this.userSubtitle,
    this.onLogout,
  );

  final List<Menu1> menu;
  final List<String> accountPermissions;
  final String userName;
  final String userSubtitle;
  final void Function() onLogout;

  static Widget prepare({
    required List<Menu1> menu,
    required List<String> accountPermissions,
    required String accountName,
    required String accountSubtitle,
    required void Function() onLogout,
  }) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MenuBloc()),
        BlocProvider(create: (_) => MenuCollapseBloc()),
      ],
      child: MenuPage._(
        menu,
        accountPermissions,
        accountName,
        accountSubtitle,
        onLogout,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.alt,
          LogicalKeyboardKey.keyP,
        ): SearchIntent(),
        LogicalKeySet(
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.alt,
          LogicalKeyboardKey.keyT,
        ): GoToTicketIntent(),
      },
      child: Actions(
        actions: {
          SearchIntent: CallbackAction(
            onInvoke: (i) {
              showSearchDialog(
                context: context,
                menu: menu,
                accountPermissions: accountPermissions,
              );
              return null;
            },
          ),
          // GoToTicketIntent: CallbackAction(
          //   onInvoke: (i) {
          //     context.read<MenuBloc>().add(
          //           Menu3Selected(
          //             home: TicketPage.prepare(
          //               department: UserRepositoryApp.instance.departmentTicket,
          //             ),
          //             label: 'Ticket',
          //           ),
          //         );
          //     return null;
          //   },
          // ),
        },
        child: BlocBuilder<MenuCollapseBloc, bool>(
          builder: (context, collapsed) {
            return ScreenIdentifierBuilder(
              builder: (context, screenIdentifier) {
                context.read<MenuCollapseBloc>().add(
                      collapsed ||
                          screenIdentifier.conditions(
                            sm: false,
                            md: true,
                            lg: false,
                          ),
                    );
                return Scaffold(
                  drawer: MenuSideNav(
                    menu: menu,
                    accountPermission: accountPermissions,
                  ),
                  appBar: screenIdentifier.conditions<bool>(sm: true, md: false)
                      ? AppBar(
                          title: const Text('Chiron'),
                          actions: [
                            AccountButton(
                              title: userName,
                              subtitle: userSubtitle,
                              onLogout: onLogout,
                            ),
                            const Gap(24),
                          ],
                        )
                      : null,
                  body: Stack(
                    children: [
                      const MenuContent(),
                      Visibility(
                        visible:
                            screenIdentifier.conditions(sm: false, md: true),
                        child: TopBar(
                          menu: menu,
                          accountName: userName,
                          accountSubtitle: userSubtitle,
                          accountPermission: accountPermissions,
                          onLogout: onLogout,
                        ),
                      ),
                      Visibility(
                        visible:
                            screenIdentifier.conditions(sm: false, md: true),
                        child: MenuSideNav(
                          menu: menu,
                          accountPermission: accountPermissions,
                        ),
                      ),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: VersionInfo(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class VersionInfo extends StatelessWidget {
  const VersionInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Opacity(
        opacity: 0.3,
        child: FutureBuilder(
          builder: (context, snapshot) {
            return Text(
              snapshot.data?.version ?? '',
              style: const TextStyle(fontSize: 12),
            );
          },
          future: PackageInfo.fromPlatform(),
        ),
      ),
    );
  }
}

class GoToTicketIntent extends Intent {}
