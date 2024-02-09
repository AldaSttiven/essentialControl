import 'package:essential_control_pc/style/styles/dark_ligth_theme.dart';
import 'package:flutter/material.dart';

class popCustom {
  Widget header, content, actions;
  BuildContext context;
  popCustom(this.context, this.header, this.content, this.actions);

  Future<void> dialog() async {
    await showDialog(
        barrierDismissible: true,
        barrierLabel: "",
        context: context,
        builder: (_) => WillPopScope(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: darkLightTheme().getBackGround()),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            header,
                            const SizedBox(height: 10.0),
                            content,
                            const SizedBox(height: 10.0),
                            actions
                          ],
                        )),
                  ),
                ),
              ),
            ),
            onWillPop: () => Future.value(true)));
  }

  Divider divider() {
    return Divider(
      height: 5,
      thickness: 1,
      endIndent: 0,
      color: darkLightTheme().getBackGround(),
    );
  }

  Widget singleChildScrollView() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(mainAxisSize: MainAxisSize.min, children: [content]));
  }
}
