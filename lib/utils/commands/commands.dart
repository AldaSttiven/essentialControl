import 'dart:async';
import 'dart:io';

import 'package:essential_control_pc/utils/server/start_server.dart';
import 'package:essential_control_pc/utils/widgets_custom/snackbarCustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Commands {
  BuildContext context;
  List<Message> lstMsg;
  Commands(this.context, this.lstMsg);

  List<String> lstComans = [];

  String folderControll = "/controlEssentials";

  run() {
    print(
        "el primer comando es desde la clase de comandos : ${lstMsg[0].msg}, module : ${lstMsg[0].module}");

    switch (lstMsg[0].module.toLowerCase()) {
      case "windows":
        //_comandsWindows(lstMsg[0]);
        executeCommands([lstMsg[0].command], 0, folderControll);
        break;
      case "youtube":
        _comandsYoutube(lstMsg[0]);
        break;
      case "spotify":
        _comandsSpotify(lstMsg[0]);
        break;
      case "devicesync":
        snackBarCustom().showSnackBar(context, "Conexion establecida", "");
        break;
      case "mobile":
        sendKeyEventAndroid(lstMsg[0]);
        break;
    }
  }

  void sendKeyEventAndroid(Message m) {
    executeCommands([m.command], 0, "");
  }

  _comandsSpotify(Message m) {
    executeCommands([m.command], 0, "");
  }

  _comandsWindows(Message m) {
    print("el comando es : ${m.command}");
    //create folder settings_essential_control
    executeCommands(['mkdir controlEssentials'], 0, "");

    _configKeysController();
  }

  _configKeysController() {
    //function F... keys
    for (int f = 0; f <= 12; f++) {
      print("llego a las teclas funtion $f");
      lstComans = [
        "echo set wShell = createObject(“wscript.shell”) > F${f}Key.vbs",
        "echo wShell.sendKeys “{F${f}}” >> F${f}Key.vbs"
      ];

      executeCommands(lstComans, 0, folderControll);
    }

    //enterKey
    lstComans = [
      "echo set wShell = createObject(“wscript.shell”) > enterKey.vbs",
      "echo wShell.sendKeys “{ENTER}” >> enterKey.vbs"
    ];
    executeCommands(lstComans, 0, folderControll);
    //spaceKey
    lstComans = [
      "echo set wShell = createObject(“wscript.shell”) > spaceKey.vbs",
      "echo wShell.sendKeys “{SPACE}” >> spaceKey.vbs"
    ];
    executeCommands(lstComans, 0, folderControll);
    //top
    lstComans = [
      "echo set wShell = createObject(“wscript.shell”) > upKey.vbs",
      "echo wShell.sendKeys “{UP}” >> upKey.vbs"
    ];
    executeCommands(lstComans, 0, folderControll);
    //down
    lstComans = [
      "echo set wShell = createObject(“wscript.shell”) > downKey.vbs",
      "echo wShell.sendKeys “{DOWN}” >> downKey.vbs"
    ];
    executeCommands(lstComans, 0, folderControll);
    //rigth
    lstComans = [
      "echo set wShell = createObject(“wscript.shell”) > rightKey.vbs",
      "echo wShell.sendKeys “{RIGHT}” >> rightKey.vbs"
    ];
    executeCommands(lstComans, 0, folderControll);
    //left
    lstComans = [
      "echo set wShell = createObject(“wscript.shell”) > leftKey.vbs",
      "echo wShell.sendKeys “{LEFT}” >> leftKey.vbs"
    ];
    executeCommands(lstComans, 0, folderControll);
  }

  _comandsYoutube(Message m) {
    lstComans = [
      'Start chrome youtube.com/tv#/',
    ];

    executeCommands(lstComans, 0, folderControll);
  }

  executeCommands(List<String> cmd, int index, String folder) async {
    await getApplicationDocumentsDirectory().then((value) {
      String directory = value.path + folder;

      if (cmd[index].isNotEmpty) {
        try {
          Process.run(cmd[index], [],
                  runInShell: true, workingDirectory: directory)
              .then((value) {
            print("se esta ejecuando el comando ");
            print("${cmd[index]}, ${value.exitCode == 0 ? ' ok' : ' bad'}");
            print("code : ${value.exitCode}");
            print("${value.stdout}");
          }).whenComplete(() {
            index++;
            if (index < cmd.length) {
              executeCommands(cmd, index, folder);
            } else {
              lstComans = [];
            }
          });
        } on Exception catch (e) {
          print("Error ${e}");
        }
      }
    });
  }
}
