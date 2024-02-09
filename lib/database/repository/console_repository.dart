import 'package:essential_control_pc/database/models/console_model.dart';

abstract class ConsoleRepository {
  Future insertConsole(List<dynamic> Console);
  Future updateConsole(Console console);
  Future deleteConsole(int idConsole);
  Future deleteAllConsole();
  Future<List<Console>> getAllConsoles();
  Future<List<CommandList>> getCommads(String filtro);
}
