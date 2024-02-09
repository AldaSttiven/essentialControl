// ignore_for_file: file_names, no_logic_in_create_state
import 'package:flutter/material.dart';

import '../../style/styles/dark_ligth_theme.dart';

class SwitchCustom extends StatefulWidget {
  bool active;
  Function() funActive, funInactive;
  SwitchCustom(this.active, this.funActive, this.funInactive);

  @override
  State<SwitchCustom> createState() =>
      _SwitchCustomState(active, funActive, funInactive);
}

class _SwitchCustomState extends State<SwitchCustom> {
  bool active;
  Function() funActive, funInactive;

  _SwitchCustomState(this.active, this.funActive, this.funInactive);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            active = !active;
            if (active) {
              funActive();
            } else {
              funInactive();
            }
          });
        },
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate,
            width: 50,
            height: 25,
            decoration: BoxDecoration(
              border:
                  Border.all(color: darkLightTheme().greyDetail(), width: 0.5),
              borderRadius: BorderRadius.circular(50.0),
              color: active
                  ? darkLightTheme().getPrimaryColor()
                  : const Color(0xff696F70).withOpacity(0.15),
            ),
            child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment:
                    active ? Alignment.centerRight : Alignment.centerLeft,
                curve: Curves.decelerate,
                child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      width: 20,
                      height: 24,
                      decoration: BoxDecoration(
                          color: active
                              ? Colors.white
                              : darkLightTheme()
                                  .getPrimaryColor()
                                  .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(100.0)),
                    )))));
  }
}
