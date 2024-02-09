import 'package:essential_control_pc/style/styles/dark_ligth_theme.dart';
import 'package:flutter/material.dart';

class CheckBoxCustom extends StatefulWidget {
  bool check;
  Function funActive, funInactive;

  CheckBoxCustom(this.check, this.funActive, this.funInactive, {Key? key})
      : super(key: key);

  @override
  State<CheckBoxCustom> createState() =>
      // ignore: no_logic_in_create_state
      _CheckBoxCustomState(check, funActive, funInactive);
}

class _CheckBoxCustomState extends State<CheckBoxCustom> {
  bool check;
  Function funActive, funInactive;

  _CheckBoxCustomState(this.check, this.funActive, this.funInactive);

  @override
  Widget build(BuildContext context) {
    //print("seleccion en checkBox Widget ${this.check}");
    return InkWell(
      onTap: () {
        setState(() {
          check = !check;
          if (check) {
            funActive();
          } else {
            funInactive();
          }
        });
      },
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            shape: BoxShape.rectangle,
            color: Colors.transparent,
            border: Border.all(
                width: 1,
                color: check
                    ? darkLightTheme().getPrimaryColor()
                    : darkLightTheme().greyDetail())),
        child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: check
                ? Icon(
                    Icons.check,
                    size: 18.0,
                    color: darkLightTheme().getPrimaryColor(),
                  )
                : Container()),
      ),
    );
  }
}
