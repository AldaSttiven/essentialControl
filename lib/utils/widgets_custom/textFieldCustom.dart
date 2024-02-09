import 'package:essential_control_pc/style/styles/dark_ligth_theme.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatefulWidget {
  String hintText;
  Function(String) fun;
  TextFieldCustom(this.hintText, this.fun);

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState(hintText, fun);
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  String hintText = "";
  Function(String) fun;
  _TextFieldCustomState(this.hintText, this.fun);

  @override
  Widget build(BuildContext context) {
    return fieldTextCustom(hintText);
  }

  Widget fieldTextCustom(String hintText) => Container(
        decoration: BoxDecoration(
            color: darkLightTheme().greyDetail().withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border:
                Border.all(color: darkLightTheme().greyDetail(), width: 0.5)),
        child: TextField(
            onChanged: ((value) => fun(value)),
            style: TextStyle(color: darkLightTheme().greyDetail()),
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(color: darkLightTheme().greyDetail()))),
      );
}
