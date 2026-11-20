import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flx_core_flutter/features/menu/presentation/widgets/menu_level_1.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class FakeStorage implements Storage {
  final Map<String, dynamic> _storage = {};

  @override
  dynamic read(String key) => _storage[key];

  @override
  Future<void> write(String key, dynamic value) async => _storage[key] = value;

  @override
  Future<void> delete(String key) async => _storage.remove(key);

  @override
  Future<void> clear() async => _storage.clear();

  @override
  Future<void> close() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeStorage fakeStorage;

  setUp(() {
    fakeStorage = FakeStorage();
    HydratedBloc.storage = fakeStorage;
    SidebarMenuDisplayBloc.instance = SidebarMenuDisplayBloc();
  });

  final sampleMenu1 = Menu1(
    label: 'TRANSAKSI',
    menu: [
      Menu2(
        icon: Icons.dashboard,
        label: 'Dashboard',
        menu: [
          Menu3(label: 'Overview', home: const SizedBox()),
        ],
      ),
      Menu2(
        icon: Icons.shopping_cart,
        label: 'Purchasing',
        menu: [
          Menu3(label: 'Order', home: const SizedBox()),
        ],
      ),
    ],
  );

  group('SidebarMenuDisplay & Bloc Unit Tests', () {
    test('default display is iconsAndLabels with showMenuName true', () {
      final bloc = SidebarMenuDisplayBloc();
      expect(bloc.state, SidebarMenuDisplay.iconsAndLabels);
      expect(bloc.state.showMenuName, isTrue);
      expect(bloc.state.label, 'Icons & Labels');
    });

    test('can switch to iconsOnly with showMenuName false', () {
      final bloc = SidebarMenuDisplayBloc()..emit(SidebarMenuDisplay.iconsOnly);
      expect(bloc.state, SidebarMenuDisplay.iconsOnly);
      expect(bloc.state.showMenuName, isFalse);
      expect(bloc.state.label, 'Icons Only');
    });

    test('toJson and fromJson work correctly', () {
      final bloc = SidebarMenuDisplayBloc();
      final json = bloc.toJson(SidebarMenuDisplay.iconsOnly);
      expect(json, {'value': 'iconsOnly'});
      expect(bloc.fromJson(json!), SidebarMenuDisplay.iconsOnly);

      final jsonDefault = bloc.toJson(SidebarMenuDisplay.iconsAndLabels);
      expect(jsonDefault, {'value': 'iconsAndLabels'});
      expect(bloc.fromJson(jsonDefault!), SidebarMenuDisplay.iconsAndLabels);
    });
  });

  group('MenuLevel1 Widget Tests', () {
    testWidgets(
        'shows menu text label when collapsed and showMenuName is true '
        '(default)', (tester) async {
      MenuBloc.instance = MenuBloc();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuLevel1(
              menu1: sampleMenu1,
              index: 0,
              isCollapsed: true,
              accountPermissions: const [],
              bypassPermission: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.dashboard), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Purchasing'), findsOneWidget);
    });

    testWidgets(
        'hides menu text label when collapsed and showMenuName is false',
        (tester) async {
      MenuBloc.instance = MenuBloc();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuLevel1(
              menu1: sampleMenu1,
              index: 0,
              isCollapsed: true,
              accountPermissions: const [],
              bypassPermission: true,
              showMenuName: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.dashboard), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      // Labels should not be visible as Text widgets
      expect(find.text('Dashboard'), findsNothing);
      expect(find.text('Purchasing'), findsNothing);
    });
  });

  group('AccountButton & Appearance Option Tests', () {
    testWidgets('Appearance option is hidden when withAppearance is false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AccountButton.showProfilePopUp(
                    context: context,
                    title: 'Admin Voltunes',
                    subtitle: 'AFS - AC',
                    onLogout: () {},
                    onChangePassword: (_) {},
                  );
                },
                child: const Text('Open Profile'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
      expect(find.text('Appearance'), findsNothing);
    });

    testWidgets('Appearance option is shown when withAppearance is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AccountButton.showProfilePopUp(
                    context: context,
                    title: 'Admin Voltunes',
                    subtitle: 'AFS - AC',
                    onLogout: () {},
                    onChangePassword: (_) {},
                    withAppearance: true,
                  );
                },
                child: const Text('Open Profile'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
    });
  });

  group('AppearanceDialog Tests', () {
    testWidgets('Appearance dialog renders correctly and saves selection',
        (tester) async {
      SidebarMenuDisplayBloc.instance = SidebarMenuDisplayBloc();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showAppearanceDialog(context: context),
                child: const Text('Open Appearance'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Appearance'));
      await tester.pumpAndSettle();

      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Sidebar Menu Display'), findsOneWidget);
      expect(
        find.text(
          'Choose whether to show or hide the menu names in the sidebar',
        ),
        findsOneWidget,
      );
      expect(find.text('Icons & Labels'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);

      // Open popup menu to choose Icons Only
      await tester.tap(find.text('Icons & Labels'));
      await tester.pumpAndSettle();

      expect(find.text('Icons Only'), findsOneWidget);
      await tester.tap(find.text('Icons Only'));
      await tester.pumpAndSettle();

      // Tap Save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(
        SidebarMenuDisplayBloc.instance.state,
        SidebarMenuDisplay.iconsOnly,
      );
    });
  });
}
