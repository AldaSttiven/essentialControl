import 'dart:io';

import 'package:essential_control_pc/utils/server/start_server.dart';
import 'package:uuid/uuid.dart';
import 'package:essential_control_pc/database/models/console_model.dart';
import 'package:essential_control_pc/style/styles/dark_ligth_theme.dart';
import 'package:essential_control_pc/utils/helpers/downloadIcons.dart';
import 'package:essential_control_pc/utils/widgets_custom/textFieldCustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/shared_preferences/s_p_conecction_server.dart';

class createConsole extends StatefulWidget {
  BuildContext context;
  late Communication comm;
  createConsole(this.context, this.comm, {super.key});

  @override
  State<createConsole> createState() => _createConsoleState();
}

class _createConsoleState extends State<createConsole> {
  bool isShowIcons = false, isShowSubCommand = false;
  String iconPathDefault =
      '/storage/emulated/0/Android/data/com.essentialsapps.essential_control_pc/files/AldaSttiven-IconsEssentialControl-a6de906/icons/layers-minimalistic-svgrepo-com.svg';
  String iconCommand =
      '/storage/emulated/0/Android/data/com.essentialsapps.essential_control_pc/files/AldaSttiven-IconsEssentialControl-a6de906/icons/programming-svgrepo-com.svg';
  List<CommandList> lstCommmands = [];

  String nameConsole = '', nameCommand = '', commandSet = '';

  @override
  Widget build(BuildContext context) => _getWidowSheet();

  Widget _getWidowSheet() => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  headerSheet(),
                  Container(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          color: darkLightTheme().getBackGround()),
                      child: SafeArea(
                        minimum: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Wrap(
                          children: [
                            const SizedBox(height: 30),
                            Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nombre y icono de la consola",
                                      style: TextStyle(
                                          color:
                                              darkLightTheme().textPrimary()),
                                    ),
                                    Row(children: [
                                      Expanded(
                                          flex: 7,
                                          child: TextFieldCustom(
                                              "Nombre de la consola",
                                              (String data) {
                                            nameConsole = data;
                                            setState(() {});
                                          })),
                                      const SizedBox(width: 10),
                                      Expanded(flex: 3, child: addIcon()),
                                    ]),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Wrap(children: [visibleIcons()]),
                                const SizedBox(height: 10),
                                Wrap(children: [_getWidgetCommand()]),
                                const SizedBox(height: 10),
                                Wrap(children: [
                                  visibleCreateSubCommand(),
                                ]),
                                const SizedBox(height: 10),
                                _getListSubCommands(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _btnFloating(Icons.check, () {
                                  print(lstCommmands.toString());
                                }),
                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      );

  Row headerSheet() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: darkLightTheme().getBackGround(),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0))),
            child: Center(
                child: Text("Crear consola",
                    style: TextStyle(
                        color: darkLightTheme().textPrimary(), fontSize: 15))),
          ),
        ),
      ],
    );
  }

  Widget visibleIcons() => Visibility(
        visible: isShowIcons,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                    future: downloadIcons().fetchFiles(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          height: 200,
                          decoration: decorationContainer(),
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 5,
                            addAutomaticKeepAlives: true,
                            children: List.generate(snapshot.data!.length,
                                (index) => photo(index, snapshot.data!)),
                          ),
                        );
                      } else {
                        return CircularProgressIndicator(
                            color: darkLightTheme().getPrimaryColor());
                      }
                    }),
              ],
            ),
          ),
        ),
      );

  BoxDecoration decorationContainer() {
    return BoxDecoration(
      color: darkLightTheme().greyDetail().withOpacity(0.1),
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      //border: Border.all(color: darkLightTheme().greyDetail(), width: 0.5)
    );
  }

  BoxDecoration decorationContainerBorder() {
    return BoxDecoration(
        color: darkLightTheme().greyContainer(),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: darkLightTheme().greyDetail(), width: 0.5));
    //border: Border.all(color: darkLightTheme().greyDetail(), width: 0.5));
  }

  Widget photo(int index, List<dynamic> lstFiles) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            iconPathDefault = (lstFiles[index] as File).path;
            print("escogio : ${(lstFiles[index] as File).path}");
            setState(() {});
          },
          child: SizedBox(
            width: 25,
            height: 25,
            child: SvgPicture.file(
              lstFiles[index],
              color: darkLightTheme().greyDetail(),
            ),
          ),
        ),
      ],
    );
  }

  Row addIcon() => Row(
        children: [
          Expanded(
            child: Container(
              decoration: decorationContainerBorder(),
              height: 50,
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: SvgPicture.file(
                        File(iconPathDefault),
                        color: darkLightTheme().textPrimary(),
                      ),
                    ),
                    Text(
                      "Editar icono",
                      style: TextStyle(
                          color: darkLightTheme().greyDetail(), fontSize: 10),
                    )
                  ],
                ),
                onTap: () {
                  isShowIcons = !isShowIcons;
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      );

  Row createFun() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 50,
            width: 50,
            child: OutlinedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: darkLightTheme().getOscureLigth(),
                  elevation: 0),
              child: Icon(Icons.check),
              onPressed: () {
                List<Console> lstConsole = [];
                lstConsole.add(Console(
                    id: const Uuid().v1().toString(),
                    name: nameConsole,
                    image: iconPathDefault,
                    commandList: lstCommmands));
              },
            ),
          ),
        ],
      );

  Widget _getWidgetCommand() => InkWell(
        onTap: () {
          isShowSubCommandChange();
        },
        child: Column(
          children: [
            Visibility(
              visible: !isShowSubCommand,
              child: Container(
                  decoration: decorationContainerBorder(),
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 5.0),
                          child: SvgPicture.file(
                            File(iconCommand),
                            color: darkLightTheme().greyDetail(),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 5.0),
                        child: Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text("Crea un comando para la consola",
                              style: TextStyle(
                                  color: darkLightTheme().greyDetail(),
                                  fontSize: 16)),
                        )),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      );

  void isShowSubCommandChange() {
    isShowSubCommand = !isShowSubCommand;
    setState(() {});
  }

  Widget _btnFloating(IconData i, Function fun) => Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      width: 55,
      height: 55,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        onPressed: () async {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          FocusScope.of(context).unfocus();
          fun();
        },
        backgroundColor: darkLightTheme().greyContainer(),
        child: Icon(
          i,
          color: darkLightTheme().greyDetail(),
        ),
      ));

  Widget visibleCreateSubCommand() => Container(
        child: Visibility(
          visible: isShowSubCommand,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Crear comando para la consola",
                  style: TextStyle(color: darkLightTheme().textPrimary()),
                ),
                Container(
                  decoration: decorationContainer(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        TextFieldCustom("Nombre del comando", (String data) {
                          nameCommand = data;
                          print("escribiendo nombre : $nameCommand");

                          setState(() {});
                        }),
                        const SizedBox(height: 10),
                        TextFieldCustom("Comando", (String data) {
                          commandSet = data;
                          print("escribiendo comando : $commandSet");

                          setState(() {});
                        }),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _btnFloating(Icons.check, () {
                              print(
                                  "Tratando de guardar los datos : ${nameCommand}, ${commandSet}");
                              lstCommmands.add(CommandList(
                                  id: lstCommmands.length,
                                  name: nameCommand,
                                  image: iconCommand,
                                  command: commandSet));
                              isShowSubCommandChange();
                              setState(() {});
                            }),
                            _btnFloating(
                                Icons.close, () => isShowSubCommandChange()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _getListSubCommands() {
    List<Widget> lst = [];
    for (CommandList element in lstCommmands) {
      lst.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                  decoration: decorationContainerBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SvgPicture.file(
                          File(iconCommand),
                          color: darkLightTheme().greyDetail(),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  element.name.toString(),
                                  style: TextStyle(
                                      color: darkLightTheme().greyDetail()),
                                ),
                                Text(element.command.toString(),
                                    style: TextStyle(
                                        color: darkLightTheme().orange())),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                _btnFloating(Icons.play_arrow_outlined, () {
                                  print(element.command);
                                  String alias =
                                      SharedPrerencesConnectionServer()
                                          .eliasDeviceSession;
                                  String ip = SharedPrerencesConnectionServer()
                                      .sessionIpConnecting;
                                  print(
                                      "conectando => ip : ${ip}, alias : ${alias}, ${element.name}, ${element.command}");
                                  widget.comm.sendMessage(
                                      SharedPrerencesConnectionServer()
                                          .sessionIpConnecting,
                                      element.name.toString(),
                                      element.name.toString(),
                                      element.command.toString(),
                                      alias);
                                })
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ));
    }
    return lstCommmands.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Lista de comandos",
                  style: TextStyle(color: darkLightTheme().orange())),
              SizedBox(
                  height: 200,
                  child: SingleChildScrollView(child: Column(children: lst))),
            ],
          )
        : SizedBox();
  }
}
