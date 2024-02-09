import 'package:essential_control_pc/style/styles/dark_ligth_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class KioskoConsole extends StatefulWidget {
  const KioskoConsole({super.key});

  @override
  State<KioskoConsole> createState() => _KioskoConsoleState();
}

class _KioskoConsoleState extends State<KioskoConsole> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: darkLightTheme().getBackGround(),
        child: Column(
          children: [
            Center(
                child: Text("este es el widget",
                    style: TextStyle(color: darkLightTheme().textPrimary()))),
          ],
        ));
  }
}
