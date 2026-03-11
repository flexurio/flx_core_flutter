import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default Menu Page', type: MenuPage)
Widget menuPageUseCase(BuildContext context) {
  return MenuPage.prepare(
    appName: 'Flx Studio',
    menu: [
      Menu1(
        label: 'Dashboard',
        menu: [
          Menu2(
            label: 'Analytics',
            icon: Icons.analytics,
            menu: [
              Menu3(label: 'Realtime', home: const Center(child: Text('Realtime Analytics'))),
              Menu3(label: 'History', home: const Center(child: Text('History Analytics'))),
            ],
          ),
        ],
      ),
      Menu1(
        label: 'Settings',
        menu: [
          Menu2(
            label: 'System',
            icon: Icons.settings,
            menu: [
              Menu3(label: 'General', home: const Center(child: Text('General Settings'))),
              Menu3(label: 'Security', home: const Center(child: Text('Security Settings'))),
            ],
          ),
        ],
      ),
    ],
    accountPermissions: [],
    accountName: 'John Doe',
    accountSubtitle: 'Administrator',
    onLogout: () {},
    onChangePassword: (context) {},
    searchData: (context, query) => [],
  );
}
