import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'status_connection_event.dart';
part 'status_connection_state.dart';

class StatusConectionBloc
    extends Bloc<StatusConectionEvent, StatusConectionState> {
  StatusConectionBloc() : super(const StatusConectionState()) {
    on<StatusConectionInitial>((event, emit) async {
      print("llego al estado intial");
    });

    on<StatusConectionChange>((event, emit) async {
      print("respuesta del estado de conection ${event.status}");
      emit(StatusConectionSetState(event.status));
      emit(StatusConectionInitialState());
    });
  }
}
