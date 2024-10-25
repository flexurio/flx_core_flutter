import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flexurio_erp_core/src/app/bloc/theme/theme_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> run({
  required FlavorConfig config,
  required Widget app,
  required void Function() initialized,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  flavorConfig = config;

  late Directory storageDirectory;

  if (kIsWeb) {
    storageDirectory = HydratedStorage.webStorageDirectory;
  } else if (Platform.isWindows) {
    storageDirectory = Directory(
      '${(await getApplicationDocumentsDirectory()).path}/chiron-${config.companyId}/data/',
    );
  } else {
    storageDirectory = await getTemporaryDirectory();
  }

  final storage = await HydratedStorage.build(
    storageDirectory: storageDirectory,
  );

  Hive.init(storageDirectory.path);

  HydratedBlocOverrides.runZoned(
    () {
      initialized();

      runApp(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('id')],
          path: 'asset/translation',
          fallbackLocale: const Locale('en'),
          child: app,
        ),
      );
    },
    storage: storage,
  );
}

class App extends StatelessWidget {
  const App({
    this.home,
    this.routerConfig,
    super.key,
  });

  final Widget? home;
  final RouterConfig<Object>? routerConfig;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
      bloc: ThemeBloc.instance,
      builder: (context, state) {
        return MaterialApp.router(
          title: applicationName,
          theme: MyTheme.getTheme(flavorConfig.color, state),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: routerConfig,
        );
      },
    );
  }
}
