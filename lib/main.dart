import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:essential_control_pc/routes/routes.dart';
import 'package:essential_control_pc/screen/principal/views/principal.dart';
import 'package:essential_control_pc/style/styles/dark_ligth_theme.dart';
import 'package:essential_control_pc/utils/bloc/dark_mode/dark_mode_bloc.dart';
import 'package:essential_control_pc/utils/shared_preferences/s_p_conecction_server.dart';
import 'package:essential_control_pc/utils/shared_preferences/s_p_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.white));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await SharedPrerencesSettins().initPrefs();
  await SharedPrerencesConnectionServer().initPrefs();
  if (!Platform.isAndroid && !Platform.isIOS) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(400, 550);
      win.minSize = initialSize;
      win.maxSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.show();
    });
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<DarkModeBloc>(
            create: (_) => DarkModeBloc()), // Proporciona ClockBloc aquí
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: darkLightTheme().getPrimaryColor(),
        fontFamily: "Montserrat",
        appBarTheme: AppBarTheme(color: darkLightTheme().getPrimaryColor()),
      ),
      home: const Scaffold(body: Principal()),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (_) => Principal.route(),
      routes: getApplicationRoutes(),
    );
  }
}
