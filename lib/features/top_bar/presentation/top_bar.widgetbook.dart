import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default Top Bar', type: TopBar)
Widget topBarUseCase(BuildContext context) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => MenuCollapseBloc()),
    ],
    child: Scaffold(
      body: Column(
        children: [
          TopBar(
            accountName: 'John Doe',
            accountSubtitle: 'Administrator',
            menu: [
              Menu1(
                label: 'Dashboard',
                menu: [
                  Menu2(
                    label: 'Analytics',
                    icon: Icons.analytics,
                    menu: [
                      Menu3(label: 'Realtime', home: const SizedBox()),
                    ],
                  ),
                ],
              ),
            ],
            accountPermission: const [],
            onLogout: () {},
            drawerTriggered: () {},
            onChangePassword: (context) {},
            searchData: (context, query) => [
              const ListTile(
                leading: Icon(Icons.search),
                title: Text('Search Result'),
              ),
            ],
            logoNamedUrl: null,
          ),
          const Expanded(
            child: Center(
              child: Text('Main Content Area'),
            ),
          ),
        ],
      ),
    ),
  );
}
