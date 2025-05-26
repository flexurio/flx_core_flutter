import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flx_core_flutter/src/app/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_core_flutter/src/app/util/storage_init.dart';

Future<void> run({
  required FlavorConfig config,
  required Widget app,
  required void Function() initialized,
}) async {
  await EasyLocalization.ensureInitialized();

  flavorConfig = config;

  await storageInit(config.companyId);
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
