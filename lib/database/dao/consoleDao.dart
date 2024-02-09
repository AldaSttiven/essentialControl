import 'dart:convert';

import 'package:essential_control_pc/database/models/console_model.dart';
import 'package:essential_control_pc/database/repository/console_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

class ConsoleDao extends ConsoleRepository {
  final Database _database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store("console_store");

  Future<Object?> insertConsole(List<dynamic> data) async {
    print("se registro : ${data}");
    return await _store.add(_database, data);
  }

  Future clearConsoleId(int idProceso, int consecutivo) async {
    await _store.delete(_database,
        finder: Finder(
            filter: containsMapFilter(
                {'consecutivo': consecutivo, 'idProceso': idProceso})));
  }

  Filter containsMapFilter(Map<String, Object?> map) {
    return Filter.custom((record) {
      var data = record.value as Map;
      for (var entry in map.entries) {
        if (data[entry.key] != entry.value) {
          return false;
        }
      }
      return true;
    });
  }

  Future<List<List<Console>>> getAllRegistros() async {
    final snapshots = await _store.find(_database);
    List<List<Console>> lstRespuesta = [];
    for (var i in snapshots) {
      if ((jsonDecode(jsonEncode(i.value)) as List).isNotEmpty) {
        print("consultando el item de los registros : $i");
        lstRespuesta.add((jsonDecode(jsonEncode(i.value)) as List)
            .map((data) => Console.fromJson(data))
            .toList());
      }
    }

    print("Encontro registro guardados : ${lstRespuesta.length}");
    return lstRespuesta;
  }

  @override
  Future deleteAllConsole() async {
    // TODO: implement deleteAllConsole
    print('elimino de la base local');
    return await _store.delete(_database);
  }

  @override
  Future deleteConsole(int idConsole) async {
    // TODO: implement deleteConsole
    await _store.delete(_database,
        finder: Finder(filter: containsMapFilter({'id': idConsole})));
  }

  @override
  Future<List<Console>> getAllConsoles() async {
    final snapshots = await _store.find(_database);
    List<Console> lstRespuesta = [];
    for (var i in snapshots) {
      if ((jsonDecode(jsonEncode(i.value)) as List).isNotEmpty) {
        print("consultando el item de los registros : $i");
        //lstRespuesta.add(Console.fromJson(i.value));
      }
    }

    print("Encontro registro guardados : ${lstRespuesta.length}");
    return lstRespuesta;
  }

  @override
  Future<List<CommandList>> getCommads(String idConsole) async {
    // TODO: implement getCommads
    List<CommandList> lst = [];

    await _store.delete(_database,
        finder: Finder(filter: containsMapFilter({'id': idConsole})));

    return lst;
  }

  @override
  Future updateConsole(Console console) {
    // TODO: implement updateConsole
    throw UnimplementedError();
  }
}
