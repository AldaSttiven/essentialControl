import 'package:shared_preferences/shared_preferences.dart';

class SharedPrerencesSettins {
  // implementando el patron singleton para que solo se genere una instancie unica para toda la aplicacion
  static final SharedPrerencesSettins _instancia =
      SharedPrerencesSettins._internal();

  // constructor factory
  factory SharedPrerencesSettins() {
    return _instancia;
  }

  SharedPrerencesSettins._internal();

  // se inicializa
  late SharedPreferences _prefs;

  initPrefs() async {
    // se hace privado para garantizar que no se accesible desde afuera
    _prefs = await SharedPreferences.getInstance();
  }

  bool get onDarkTheme {
    return _prefs.getBool('dark') ?? true;
  }

  set onDarkTheme(bool value) {
    _prefs.setBool('dark', value);
  }
}
