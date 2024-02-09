import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:essential_control_pc/screen/principal/widgets/consoleStausMessage.dart';
import 'package:essential_control_pc/screen/console/views/createConsole.dart';
import 'package:essential_control_pc/screen/principal/widgets/kiosko.dart';
import 'package:essential_control_pc/screen/principal/widgets/menu.dart';
import 'package:essential_control_pc/style/styles/dark_ligth_theme.dart';
import 'package:essential_control_pc/utils/bloc/dark_mode/dark_mode_bloc.dart';
import 'package:essential_control_pc/utils/commands/commands.dart';
import 'package:essential_control_pc/utils/helpers/downloadIcons.dart';
import 'package:essential_control_pc/utils/helpers/svg_util.dart';
import 'package:essential_control_pc/utils/widgets_custom/popCustom.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../utils/server/start_server.dart';
import '../../../utils/shared_preferences/s_p_conecction_server.dart';
import '../../../utils/widgets_custom/drawerSideCustom.dart';
import 'package:essential_control_pc/utils/widgets_custom/snackbarCustom.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const Principal());
  }

  static const String routeName = "principal";

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  String? Address;
  TextEditingController txtController = TextEditingController();
  TextEditingController txtControllerConection = TextEditingController();
  late Communication comm;
  bool isCodeQR = false;
  bool isTV = false;

  @override
  void initState() {
    createComm();

    super.initState();
    isTV_detect();
  }

  isTV_detect() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    isTV = androidInfo.systemFeatures.contains('android.software.leanback');
    print("detecto que es un televisor :$isTV");
    setState(() {});
  }

  Future<String?> myLocalIp() async {
    final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4, includeLinkLocal: true);
    return interfaces
        .where((e) => e.addresses.first.address.indexOf('192.') == 0)
        .first
        .addresses
        .first
        .address;
  }

  @override
  Widget build(BuildContext context) {
    Address =
        "${SharedPrerencesConnectionServer().eliasDeviceSession} - ${SharedPrerencesConnectionServer().ipPort}";

    if (isCodeQR) {
      Navigator.of(context).pop();
      isCodeQR = false;
      setState(() {});
    }
    return blocListener();
  }

  void getDataInfoRquest() {
    final message = comm.messages[0];
    print("llegaron los mensajes ddd : ${comm.messages[0].module}");
    if (message.module == 'DeviceSession') {
      print("es intenta cambiar el stado del appBar");
      Address = "${message.msg}";
    } else {
      print(
          "no fue posible cambiar el stado del appBar : ${Address.toString().split(":")[0]} ${message.ip}");
    }
  }

  Future<void> createComm() async {
    comm = Communication(context, (value, ipResq, alias) {
      Commands(context, comm.messages).run();
      validateSyncDevices(value, ipResq, alias);
      setState(() {});
    });

    await comm.startServe();
  }

  void validateSyncDevices(String value, String ipResq, String alias) {
    switch (value) {
      case "DevicesSync":
        snackBarCustom().showSnackBar(
            context, "Se sincronizo con ${alias ?? ipResq}", "dark");
        comm.sendMessage(
            ipResq,
            "Respondiendo solicitud",
            "DevicesSyncResponse",
            "",
            SharedPrerencesConnectionServer().eliasDeviceSession);
        break;
      case "DevicesSyncResponse":
        snackBarCustom().showSnackBar(
            context, "Se sincronizo con ${alias ?? ipResq}", "dark");
        break;
    }
  }

  Widget blocListener() => MultiBlocListener(
          listeners: [
            BlocListener<DarkModeBloc, DarkModeState>(
              listener: ((context, state) {
                setState(() {});
              }),
            ),
          ],
          child: Scaffold(
            backgroundColor: darkLightTheme().getBackGround(),
            drawer: myDrawer(),
            appBar: _appBar(),
            body: Platform.isAndroid || Platform.isIOS
                ? isTV
                    ? listenActionsWave()
                    : _body()
                : listenActionsWave(),
            floatingActionButton:
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              _btnFloating(Icons.sync_alt_outlined, () {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                FocusScope.of(context).unfocus();
                downloadIcons().downloadIconsGet();
              }),
              const SizedBox(width: 10),
              _btnFloating(Icons.code, () {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                FocusScope.of(context).unfocus();
                activeSheetSolicititacion(consoleMessage(comm: comm));
              }),
              const SizedBox(width: 10),
              _btnFloating(Icons.add, () {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                FocusScope.of(context).unfocus();
                activeSheetSolicititacion(createConsole(context, comm));
              })
            ]),
          ));

  Row listenActionsWave() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
                color: darkLightTheme().getPrimaryColor(), size: 120),
            Text(
              "Esperando acciones...",
              style: TextStyle(color: darkLightTheme().textSecundary()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _btnFloating(IconData i, Function f) => Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      width: 55,
      height: 55,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        onPressed: () async {
          f();
        },
        backgroundColor: darkLightTheme().greyContainer(),
        child: Icon(
          i,
          color: darkLightTheme().greyDetail(),
        ),
      ));

  void activeSheetSolicititacion(Widget panel) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return panel;
        });
  }

  Widget bottomSheetAddConsole() => FractionallySizedBox(
        child: Container(
            decoration: BoxDecoration(color: darkLightTheme().getBackGround()),
            child: Center(child: Text("hola mundo"))),
      );

  Widget myDrawer() => DrawerSideCustom(
        comm: comm,
        context: context,
        adminPhotos: true,
        adminUserInfo: false,
        assingFarm: true,
        blockedWifi: true,
        closeSesion: true,
        localdata: false,
        routePaint: 'menuFormularioPage',
      );

  AppBar _appBar() => AppBar(
        iconTheme:
            IconThemeData(color: darkLightTheme().getPrimaryColor(), size: 20),
        backgroundColor: Colors.black87.withOpacity(0.04),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("essential_control",
                style: TextStyle(
                    color: darkLightTheme().getPrimaryColor(), fontSize: 15)),
            Text(
              Address.toString().split(":")[0].toString(),
              style: TextStyle(
                  color: darkLightTheme().textSecundary(), fontSize: 12),
            ),
          ],
        ),
        actions: [actionAppBarDesktop(), actionAppBarMobile()],
        elevation: 0,
      );

  Row actionAppBarMobile() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              FlutterBarcodeScanner.scanBarcode(
                      '#ffffff', 'Cancel', false, ScanMode.QR)
                  .then((value) {
                print("scaneado => $value");
                txtControllerConection.text = value == '-1' ? '' : value;
                comm.sendMessage(value, "Solicitando conexion", "DevicesSync",
                    "", SharedPrerencesConnectionServer().eliasDeviceSession);
                setState(() {});
              });
            },
            child: SvgUtil().buildSvgPicture(
                "assets/icon/scan.svg", darkLightTheme().greyDetail(), 30),
          ),
        ),
      ],
    );
  }

  Row actionAppBarDesktop() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              isCodeQR = true;
              popCustom(
                      context,
                      Text(
                          "Escanea este codigo para que otros dispositivos se conecten",
                          style: TextStyle(
                              color: darkLightTheme().textSecundary())),
                      QrImageView(
                        data: SharedPrerencesConnectionServer()
                            .ipPort
                            .split(":")[0],
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                      Container())
                  .dialog();
            },
            child: SvgUtil().buildSvgPicture(
                "assets/icon/qr.svg", darkLightTheme().greyDetail(), 30),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              exit(0);
            },
            child: SvgUtil().buildSvgPicture(
                "assets/icon/close.svg", darkLightTheme().greyDetail(), 30),
          ),
        ),
      ],
    );
  }

  Widget _body() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [fieldTextCustom(), KioskoConsole(), mediaOptions()],
      );

  Widget mediaOptions() => Expanded(
        child: OrientationBuilder(
          builder: (context, orientation) => GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
            ),
            children: [
              _onWidgetMedia("youtube", "assets/icon_media/youtube.svg",
                  "Start chrome youtube.com/tv#/"),
              _onWidgetMedia(
                  "spotify", "assets/icon_media/spotify.svg", "Start spotify"),
              _onWidgetMedia(
                  "windows", "assets/icon_media/windows.svg", "SyncConfig")
            ],
          ),
        ),
      );

  Widget fieldTextCustom() => Container(
        decoration: BoxDecoration(
            color: darkLightTheme().getPrimaryColor().withOpacity(0.5)),
        child: TextField(
            style: const TextStyle(color: Colors.white),
            textCapitalization: TextCapitalization.sentences,
            controller: txtControllerConection,
            onChanged: (value) =>
                SharedPrerencesConnectionServer().sessionIpConnecting = value,
            decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.connected_tv_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                hintText: "IP del dispositivo",
                hintStyle: TextStyle(color: Colors.white))),
      );

  //"powercfg.exe /hibernate"
  Widget _onWidgetMedia(String title, String icon, String openCommand) =>
      GestureDetector(
          /*onLongPressStart: (value) => menuPop().showCustomMenu(
              context, value.globalPosition, title, icon, openCommand),*/
          onTap: () {
            print("llego aqui");
            String alias = SharedPrerencesConnectionServer().eliasDeviceSession;
            comm.sendMessage(
                txtControllerConection.text, title, title, openCommand, alias);
          },
          child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: darkLightTheme().getBackGround(),
                  border: Border.all(
                      color: darkLightTheme().textSecundary(), width: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
              height: 20,
              width: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgUtil()
                      .buildSvgPicture(icon, darkLightTheme().greyDetail(), 70),
                  Text(
                    title,
                    style: TextStyle(
                        color: darkLightTheme().greyDetail(),
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0),
                  ),
                ],
              )));
}
