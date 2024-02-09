import 'dart:async';
import 'dart:io';
import 'package:essential_control_pc/utils/bloc/dark_mode/dark_mode_bloc.dart';
import 'package:essential_control_pc/utils/helpers/response_size.dart';
import 'package:essential_control_pc/utils/helpers/svg_util.dart';
import 'package:essential_control_pc/utils/server/start_server.dart';
import 'package:essential_control_pc/utils/shared_preferences/s_p_conecction_server.dart';
import 'package:essential_control_pc/utils/shared_preferences/s_p_settings.dart';
import 'package:essential_control_pc/utils/widgets_custom/switchCustom.dart';
import 'package:essential_control_pc/utils/widgets_custom/textFieldCustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../style/styles/dark_ligth_theme.dart';

class DrawerSideCustom extends StatefulWidget {
  DrawerSideCustom(
      {Key? key,
      required this.comm,
      required this.context,
      required this.adminUserInfo,
      required this.assingFarm,
      required this.adminPhotos,
      required this.blockedWifi,
      required this.localdata,
      required this.closeSesion,
      required this.routePaint})
      : super(key: key);

  final BuildContext context;
  final bool adminUserInfo,
      assingFarm,
      adminPhotos,
      blockedWifi,
      localdata,
      closeSesion;
  final String routePaint;
  Communication comm;

  @override
  State<DrawerSideCustom> createState() => _DrawerSideCustomState(adminUserInfo,
      assingFarm, adminPhotos, blockedWifi, localdata, closeSesion, routePaint);
}

class _DrawerSideCustomState extends State<DrawerSideCustom> {
  bool isSwitched = false; //onLine
  bool isDarkSwitched = false; //theme dark

  final bool _adminUserInfo,
      _assingFarm,
      _adminPhotos,
      _blockedWifi,
      _localdata,
      _closeSesion;
  final String routePaint;
  String pathSended = "";

  _DrawerSideCustomState(
      this._adminUserInfo,
      this._assingFarm,
      this._adminPhotos,
      this._blockedWifi,
      this._localdata,
      this._closeSesion,
      this.routePaint);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  double sizeIcons = 25, sizeText = 13;

  late final darkBloc;

  @override
  void initState() {
    darkBloc = context.read<DarkModeBloc>();
    super.initState();
  }

  var channel = MethodChannel("exeCommand");

  showToast() {
    channel.invokeMethod("commadAdb", {'argsData': 'adb devices'});
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    print("llego al build");

    return blocListener(context);
  }

  Widget blocListener(BuildContext context) => MultiBlocListener(
        listeners: [
          BlocListener<DarkModeBloc, DarkModeState>(
            listener: ((context, state) {
              setState(() {});
            }),
          ),
        ],
        child: exampleDrawer(context),
      );

  MultiBlocListener blocListener2(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<DarkModeBloc, DarkModeState>(
        listener: (context, state) {
          print("estado del bloc darkMode en el side : ${state.props}");

          if (state is darkModeDark) {
            print("estado del bloc darkMode en el side : ${state.props}");
            setState(() {});
          } else {
            print("estado del bloc darkMode en el side : ${state.props}");
            setState(() {});
          }
        },
      )
    ], child: Container());
  }

  Widget exampleDrawer(BuildContext context) {
    return Drawer(
      elevation: 0,
      key: scaffoldKey,
      backgroundColor: darkLightTheme().getBackGround(),
      child: Column(
        children: [
          Expanded(
            flex: 12,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _header(),
                  _adminUserInfo
                      ? adminUserInfo()
                      : const SizedBox(
                          width: 0,
                        ),
                  FutureBuilder(
                      future: commadTest(),
                      builder: (context, snapshot) =>
                          Container(child: snapshot.data))
                ],
              ),
            ),
          ),
          // This container holds the align
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  goSettings(context),
                  informacionDevicesApp(),
                ],
              ))
        ],
      ),
    );
  }

  Future<Widget> commadTest() async {
    return InkWell(
        /*onTap: () async {
          obtenerRutaDescargas().then((value) {
            print('$value/PSemuX.apk');
            /*otorgarPermisoAdb('com.essentialsapps.essential_control_pc',
                'android.permission.INSTALL_PACKAGES');
            instalarAPK('$value/PSemuX.apk');*/

            
          });
        },*/
        onTap: showToast,
        child: Container(
            child: Text("Exe command",
                style: TextStyle(color: darkLightTheme().textPrimary()))));
  }

  Future<String> obtenerRutaDescargas() async {
    try {
      // Obtiene el directorio de documentos de la aplicación
      final Directory? directorioDocumentos = await getDownloadsDirectory();

      // Construye la ruta del directorio de descargas
      final String rutaDescargas = '${directorioDocumentos!.path}';
      print("rutas de descargas : $rutaDescargas");

      // Crea el directorio de descargas si no existe
      await Directory(rutaDescargas).create(recursive: true);

      return rutaDescargas;
    } catch (e) {
      print('Error al obtener la ruta de descargas: $e');
      return '';
    }
  }

  Future<void> otorgarPermisoAdb(
      String nombrePaquete, String nombrePermiso) async {
    try {
      final ProcessResult result = await Process.run(
        'adb',
        ['shell', 'pm', 'grant', nombrePaquete, nombrePermiso],
      );

      if (result.exitCode == 0) {
        print('Permiso otorgado exitosamente.');
      } else {
        print('Error al otorgar permiso. Código de salida: ${result.exitCode}');
        print('Salida del proceso: ${result.stdout}');
      }
    } catch (e) {
      print('Error al ejecutar el comando: $e');
    }
  }

  Future<void> instalarAPK(String rutaAPK) async {
    try {
      final ProcessResult result = await Process.run(
        'echo',
        [rutaAPK],
        runInShell: true,
      );

      File archivo = File(rutaAPK);
      await archivo.exists().then((value) => print(value));

      if (result.exitCode == 0) {
        final ProcessResult installResult = await Process.run(
          'pm',
          ['install', '-r', rutaAPK],
          runInShell: true,
          //stdin: result.stdout as StringStream,
        );

        if (installResult.exitCode == 0) {
          print('APK instalado exitosamente.');
        } else {
          print(
              'Error al instalar el APK. Código de salida: ${installResult.exitCode}');
          print('Salida del proceso: ${installResult.stderr}');
        }
      } else {
        print(
            'Error al ejecutar el comando. Código de salida: ${result.exitCode}');
        print('Salida del proceso: ${result.stdout}');
      }
    } catch (e) {
      print('Error al ejecutar el comando: $e');
    }
  }

  AppBar _appBar() => AppBar(
        leading: SvgUtil().buildSvgPicture("assets/icon/icon_app_white.svg",
            darkLightTheme().getPrimaryColor(), 0),
        backgroundColor: Colors.black87.withOpacity(0.04),
        title: Text("essential_control",
            style: TextStyle(
                color: darkLightTheme().getPrimaryColor(), fontSize: 15)),
        elevation: 0,
      );

  Widget _header() {
    return Container(
      decoration: BoxDecoration(color: Colors.black87.withOpacity(0.04)),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
        child: Row(
          children: [
            SizedBox(
                width: 60,
                child: SvgUtil().buildSvgPicture(
                    "assets/icon/icon_app_white.svg",
                    darkLightTheme().getPrimaryColor(),
                    30)),
            const SizedBox(width: 10),
            Text("Essential_control PC",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: darkLightTheme().getPrimaryColor(),
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget goSettings(BuildContext context) {
    print("llego al goSettings");
    return _getItemClick(
        "assets/icon/settings.svg", "Configuracion", true, SizedBox(), () {
      if (!responsiveSize.isDesktop(context)) {
        Navigator.pop(context);
      } else {
        FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      }
      sheetConfiguration();
    });
  }

  void sheetConfiguration() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return BlocBuilder<DarkModeBloc, DarkModeState>(
              builder: (context, state) {
            return blocConfigurations(context, darkBloc);
          });
        });
  }

  Widget blocConfigurations(BuildContext context, DarkModeBloc darkBloc) {
    print("llego a pintar las configuraciones");

    return BlocProvider.value(
        value: darkBloc,
        child:
            BlocBuilder<DarkModeBloc, DarkModeState>(builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: FractionallySizedBox(
                widthFactor: responsiveSize.isDesktop(context) ? 0.30 : 1,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                  decoration:
                      BoxDecoration(color: darkLightTheme().getBackGround()),
                  child: SafeArea(
                      minimum: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                                child: Text("Configuracion",
                                    style: TextStyle(
                                        color:
                                            darkLightTheme().textPrimary()))),
                            const SizedBox(height: 20),
                            eliasDevice(context),
                            Column(
                              children: [darkMode(context)],
                            )
                          ])),
                ),
              ),
            ),
          );
        }));
  }

  Widget darkMode(BuildContext context) {
    return _getItem(
        "assets/icon/dark_mode.svg",
        "Modo oscuro",
        SharedPrerencesSettins().onDarkTheme,
        SwitchCustom(SharedPrerencesSettins().onDarkTheme, () {
          isDarkSwitched = !isDarkSwitched;
          context.read<DarkModeBloc>().add(DarkModeChange());
        }, () {
          isDarkSwitched = !isDarkSwitched;
          context.read<DarkModeBloc>().add(DarkModeChange());
        }));
  }

  Widget eliasDevice(BuildContext context) {
    String elias = SharedPrerencesConnectionServer().eliasDeviceSession;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: -0.50,
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: SvgUtil().buildSvgPicture(
          "assets/icon/devices.svg", darkLightTheme().greyDetail(), 25),
      subtitle: TextFieldCustom(
          elias.isEmpty ? "Asignar nombre a la sesion" : elias, (String value) {
        print("Asignando elias : $value");
        SharedPrerencesConnectionServer().eliasDeviceSession = value;
        widget.comm.sendMessage(
            SharedPrerencesConnectionServer().sessionIpStatus,
            value,
            "DeviceSession",
            "",
            value);
      }),
    );
  }

  Widget _getItemClick(
      String path, String title, bool activate, Widget tool, Function fun) {
    return InkWell(
      onTap: () => fun(),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgUtil().buildSvgPicture(
                  path, darkLightTheme().greyDetail(), sizeIcons),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: darkLightTheme().textPrimary(),
                            fontSize: 13)),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _getItem(String path, String title, bool activate, Widget tool) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
            child: SvgUtil().buildSvgPicture(
                path, darkLightTheme().greyDetail(), sizeIcons),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: darkLightTheme().textPrimary(),
                      fontSize: sizeText)),
              Text(activate ? "Activado" : "Desactivado",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: darkLightTheme().greyDetail(),
                      fontSize: sizeText - 2))
            ]),
          ),
          tool
        ],
      ),
    );
  }

  Widget informacionDevicesApp() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
          child: Align(
              alignment: FractionalOffset.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text("V. 1.0.0.0.1",
                        style: TextStyle(
                            color: darkLightTheme().greyDetail(),
                            fontSize: sizeText)),
                  ),
                ],
              )),
        )
      ],
    );
  }

  ListTile adminUserInfo() {
    return ListTile(
      leading: Icon(
        Icons.perm_identity,
        color: darkLightTheme().textPrimary(),
        size: 25,
      ),
      title: Text(
        'Información de la sesion',
        style: TextStyle(
            color: darkLightTheme().textPrimary(), fontSize: sizeText),
      ),
      onTap: () {},
    );
  }

  ListTile assingFarm() {
    return ListTile(
      leading: SvgUtil().buildSvgPicture("assets/icon/índice.svg",
          darkLightTheme().textPrimary(), sizeText + 12),
      title: Text(
        'Administración de fincas',
        style: TextStyle(
            color: darkLightTheme().textPrimary(), fontSize: sizeText),
      ),
      onTap: () {
        if (responsiveSize.isMobile(context)) {
          Navigator.pop(context);
        }

        /*popCustom(
                context,
                Text("Administracion de fincas",
                    style: TextStyle(
                        color: darkLightTheme().textPrimary(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                //farmAsination(),
                (){},
                Container())
            .dialog();*/
      },
    );
  }

  ListTile localData() {
    return ListTile(
        leading: SvgUtil().buildSvgPicture(
            "assets/icon/data_local.svg", darkLightTheme().textPrimary(), 25),
        title: Text(
          'Datos de la aplicación',
          style: TextStyle(
              color: darkLightTheme().textPrimary(), fontSize: sizeText),
        ));
  }

  InkWell darkTheme(BuildContext context) {
    isDarkSwitched = SharedPrerencesSettins().onDarkTheme;
    return InkWell(
      child: ListTile(
        leading: SvgUtil().buildSvgPicture(
            "assets/icon/dark_mode.svg", darkLightTheme().textPrimary(), 25),
        title: Text(
          'Modo oscuro',
          style: TextStyle(
              color: darkLightTheme().textPrimary(), fontSize: sizeText),
        ),
        subtitle: Text(
          isDarkSwitched ? "configuracion activada" : "",
          style: TextStyle(
              color: darkLightTheme().orange(),
              fontSize: sizeText - 2,
              fontWeight: FontWeight.bold),
        ),
        trailing: Switch(
          activeColor: darkLightTheme().getPrimaryColor(),
          value: isDarkSwitched,
          onChanged: (value) {
            setState(() {
              isDarkSwitched = !isDarkSwitched;
              context.read<DarkModeBloc>().add(DarkModeChange());
            });
          },
        ),
        onTap: () {
          setState(() {
            isDarkSwitched = !isDarkSwitched;
            context.read<DarkModeBloc>().add(DarkModeChange());
          });
        },
      ),
    );
  }
}
