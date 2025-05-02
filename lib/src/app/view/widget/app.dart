import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/bloc/theme/theme_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> run({
  required FlavorConfig config,
  required Widget app,
  required void Function() initialized,
}) async {
  await EasyLocalization.ensureInitialized();

  flavorConfig = config;

  late String storageDirectoryPath;

  if (kIsWeb) {
    storageDirectoryPath = HydratedStorageDirectory.web.path;
  } else if (Platform.isWindows) {
    storageDirectoryPath =
        '${(await getApplicationDocumentsDirectory()).path}/chiron-${config.companyId}/data/';
  } else {
    storageDirectoryPath = (await getTemporaryDirectory()).path;
  }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  Hive.init(storageDirectoryPath);

  initialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('id')],
      path: 'asset/translation',
      fallbackLocale: const Locale('en'),
      child: app,
    ),
  );
}

class App extends StatelessWidget {
  const App({
    required this.routerConfig,
    super.key,
  });

  final RouterConfig<Object> routerConfig;

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
