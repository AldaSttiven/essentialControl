import 'package:essential_control_pc/utils/shared_preferences/s_p_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'dark_mode_event.dart';
part 'dark_mode_state.dart';

final prefs = SharedPrerencesSettins();

class DarkModeBloc extends Bloc<DarkModeEvent, DarkModeState> {
  DarkModeBloc() : super(const DarkModeState()) {
    on<DarkModeInitial>((event, emit) async {
      print("llego al estado intial");
    });

    on<DarkModeChange>((event, emit) async {
      prefs.onDarkTheme = !prefs.onDarkTheme;
      print("esta cambiando el estado a ${prefs.onDarkTheme}");
      emit(prefs.onDarkTheme ? darkModeDark() : darkModeLight());
      emit(darkModeInitial());
    });
  }
}
