import 'dart:io';

import 'package:essential_control_pc/database/dao/consoleDao.dart';
import 'package:essential_control_pc/database/repository/console_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class Init {
  static Future initialize() async {
    await _initSembast();
    _registerRepositories();
  }

  static _registerRepositories() {
    GetIt.I.registerLazySingleton<ConsoleRepository>(() => ConsoleDao());
  }

  static Future _initSembast() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, "database.db");
    final database = await databaseFactoryIo.openDatabase(databasePath);
    GetIt.I.registerSingleton<Database>(database);
  }

  Future<int> sizeDb() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);

    int size = 0;

    await for (var element in appDir.list()) {
      FileStat fs = await element.stat();
      if (element.path.endsWith('database.db')) {
        size = fs.size;
        break;
      }
    }

    return size;
  }
}
