import 'package:essential_control_pc/screen/principal/views/principal.dart';
import 'package:essential_control_pc/utils/bloc/dark_mode/dark_mode_bloc.dart';
import 'package:essential_control_pc/utils/bloc/status_conection/status_connection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    //principal
    Principal.routeName: (BuildContext context) =>
        MultiBlocProvider(providers: providers, child: const Principal()),
    //control create
  };
}

List<SingleChildWidget> get providers => [
      BlocProvider<DarkModeBloc>(create: (_) => DarkModeBloc()),
      BlocProvider<StatusConectionBloc>(create: (_) => StatusConectionBloc())
    ];
