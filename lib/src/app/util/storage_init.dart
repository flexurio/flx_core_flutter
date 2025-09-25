import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<void> storageInit(String companyId) async {
  late String storageDirectoryPath;

  if (kIsWeb) {
    storageDirectoryPath = HydratedStorageDirectory.web.path;
  } else if (Platform.isWindows) {
    final dir = await getApplicationDocumentsDirectory();
    storageDirectoryPath = p.join(dir.path, 'chiron-$companyId', 'data');
  } else {
    final dir = await getTemporaryDirectory();
    storageDirectoryPath = p.join(dir.path, 'chiron-$companyId', 'data');
  }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(storageDirectoryPath),
  );

  Hive.init(storageDirectoryPath);
}
