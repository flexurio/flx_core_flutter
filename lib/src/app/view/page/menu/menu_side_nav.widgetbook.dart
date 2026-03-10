import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/view/page/menu/menu_side_nav.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default Side Nav', type: MenuSideNav)
Widget menuSideNavUseCase(BuildContext context) {
  final menuData = [
    Menu1(
      label: 'Main Area',
      menu: [
        Menu2(
          label: 'Employee',
          icon: Icons.people,
          menu: [
            Menu3(label: 'List', home: const SizedBox()),
            Menu3(label: 'Time & Attendance', home: const SizedBox()),
            Menu3(label: 'Leave Management', home: const SizedBox()),
          ],
        ),
        Menu2(
          label: 'Settings',
          icon: Icons.settings,
          menu: [
            Menu3(label: 'General', home: const SizedBox()),
            Menu3(label: 'Security', home: const SizedBox()),
          ],
        ),
      ],
    ),
    Menu1(
      label: 'Analytics',
      menu: [
        Menu2(
          label: 'Reports',
          icon: Icons.bar_chart,
          menu: [
            Menu3(label: 'Monthly Summary', home: const SizedBox()),
            Menu3(label: 'Annual Report', home: const SizedBox()),
          ],
        ),
      ],
    ),
  ];

  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Row(
      children: [
        // Ensure that MenuCollapseBloc is available in the context.
        BlocProvider<MenuCollapseBloc>(
          create: (context) => MenuCollapseBloc(),
          child: MenuSideNav(
            menu: menuData,
            accountPermission: const [],
            bypassPermission: true,
            logoUrl: null,
            logoNamedUrl: null,
          ),
        ),
        // Placeholder for the rest of the application body.
        Expanded(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Center(
              child: Text('Main Content Area'),
            ),
          ),
        ),
      ],
    ),
  );
}
