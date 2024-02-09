part of 'status_connection_bloc.dart';

class StatusConectionState extends Equatable {
  const StatusConectionState();

  @override
  List<Object?> get props => [];
}

class StatusConectionInitialState extends StatusConectionState {}

class StatusConectionSetState extends StatusConectionState {
  String status;
  StatusConectionSetState(this.status);

  List<Object?> get props => [status];
}
