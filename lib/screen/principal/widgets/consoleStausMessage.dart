import 'package:essential_control_pc/style/styles/dark_ligth_theme.dart';
import 'package:essential_control_pc/utils/server/start_server.dart';
import 'package:flutter/material.dart';

class consoleMessage extends StatelessWidget {
  const consoleMessage({
    super.key,
    required this.comm,
  });

  final Communication comm;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        child: Container(
            decoration: BoxDecoration(color: darkLightTheme().getBackGround()),
            child: comm.messages.isNotEmpty
                ? ListView.separated(
                    itemCount: comm.messages.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final message = comm.messages[index];
                      return comm.messages.isNotEmpty
                          ? ListTile(
                              visualDensity: VisualDensity.compact,
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${message.alias.isEmpty ? '' : message.alias} ${message.ip}",
                                      style: TextStyle(
                                          color:
                                              darkLightTheme().textPrimary())),
                                  Text(message.module,
                                      style: TextStyle(
                                          color: darkLightTheme()
                                              .textSecundary())),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(message.command,
                                          style: TextStyle(
                                              color: darkLightTheme()
                                                  .textSecundary())),
                                      Text(
                                          message.dateTime.isEmpty
                                              ? ''
                                              : message.dateTime.split(".")[0],
                                          style: TextStyle(
                                              color:
                                                  darkLightTheme().orange())),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Text(
                                  "No tienes solicitudes por el momento",
                                  style: TextStyle(
                                      color: darkLightTheme().greyDetail(),
                                      fontWeight: FontWeight.bold)),
                            );
                    },
                  )
                : Center(
                    child: Text("No tienes solicitudes por el momento",
                        style: TextStyle(
                            color: darkLightTheme().greyDetail(),
                            fontWeight: FontWeight.bold)),
                  )),
      );
}
