import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> storageInit(String companyId) async {
  late String storageDirectoryPath;

  if (kIsWeb) {
    storageDirectoryPath = HydratedStorageDirectory.web.path;
  } else if (Platform.isWindows) {
    storageDirectoryPath =
        '${(await getApplicationDocumentsDirectory()).path}/chiron-$companyId/data/';
  } else {
    storageDirectoryPath = (await getTemporaryDirectory()).path;
  }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  Hive.init(storageDirectoryPath);
}
