import 'package:shared_preferences/shared_preferences.dart';

class SharedPrerencesConnectionServer {
  // implementando el patron singleton para que solo se genere una instancie unica para toda la aplicacion
  static final SharedPrerencesConnectionServer _instancia =
      SharedPrerencesConnectionServer._internal();

  // constructor factory
  factory SharedPrerencesConnectionServer() {
    return _instancia;
  }

  SharedPrerencesConnectionServer._internal();

  // se inicializa
  late SharedPreferences _prefs;

  initPrefs() async {
    // se hace privado para garantizar que no se accesible desde afuera
    _prefs = await SharedPreferences.getInstance();
  }

  String get ipPort {
    return _prefs.getString('ipPort') ?? "not found";
  }

  set ipPort(String value) {
    _prefs.setString('ipPort', value);
  }

  String get sessionIpStatus {
    return _prefs.getString('sessionIpStatus') ?? "not found";
  }

  set sessionIpStatus(String value) {
    _prefs.setString('sessionIpStatus', value);
  }

  String get sessionIpConnecting {
    return _prefs.getString('sessionIpConnecting') ?? "not found";
  }

  set sessionIpConnecting(String value) {
    _prefs.setString('sessionIpConnecting', value);
  }

  String get eliasDeviceSession {
    return _prefs.getString('eliasDeviceSession') ?? "not found";
  }

  set eliasDeviceSession(String value) {
    _prefs.setString('eliasDeviceSession', value);
  }
}
