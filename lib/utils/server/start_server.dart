import 'dart:io';

import 'package:essential_control_pc/utils/shared_preferences/s_p_conecction_server.dart';
import 'package:flutter/material.dart';

class Message {
  final String ip;
  final String alias;
  final String msg;
  final String module;
  final String command;
  final String dateTime;
  Message(
      this.ip, this.alias, this.msg, this.module, this.command, this.dateTime);
  @override
  String toString() => '{$ip, $msg}';
}

class Communication {
  Communication(
    this.context,
    this.onUpdate, {
    this.port = 8080,
  });
  final int port;
  List<Message> messages = [];
  Function(String module, String iPreq, String alias) onUpdate;
  BuildContext context;

  // Hard coded, needs improvement
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

  // start serving on given port
  Future startServe() async {
    final ip = await myLocalIp();
    var server = await HttpServer.bind(ip, port, shared: true);
    String listen = '$ip:${server.port}';
    print(listen);
    SharedPrerencesConnectionServer().ipPort = listen;

    await for (HttpRequest request in server) {
      _handleRequest(ip.toString(), request);
      request.response.write('Ok');
      await request.response.close();
    }
  }

  // Handle the request
  void _handleRequest(String to, HttpRequest request) {
    // if query has a message then add to list
    final msg = request.uri.queryParameters['msg'];
    final from = request.uri.queryParameters['ip'];
    final alias = request.uri.queryParameters['alias'];
    final command = request.uri.queryParameters['command'];
    final module = request.uri.queryParameters['module'];
    final dateTime = request.uri.queryParameters['dateTime'];

    SharedPrerencesConnectionServer().sessionIpStatus = from ?? '';
    print("la ip a la cual se esta conectando es : $from");
    if (msg != null) {
      print("llego el mensaje : $msg, el comando es : $command");
      messages.insert(
          0,
          Message(from ?? '', alias ?? '', msg ?? '', module ?? '',
              command ?? '', dateTime ?? ''));
      onUpdate(module.toString(), from.toString(), alias.toString());
    }
  }

  // Send message all
  void sendMessage(String to, String msg, String module, String command,
      String alias) async {
    final ip = await myLocalIp();
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);
    try {
      final resp = await client.get(to, port,
          "?ip=$ip&alias=${alias}&msg=$msg&module=$module&command=$command&dateTime=${DateTime.now()}");
      print(resp.bufferOutput);
      resp.close();
    } catch (message) {
      print(message);
    }
  }
}
