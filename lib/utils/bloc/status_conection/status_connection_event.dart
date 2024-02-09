part of 'status_connection_bloc.dart';

abstract class StatusConectionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StatusConectionInitial extends StatusConectionEvent {}

class StatusConectionChange extends StatusConectionEvent {
  String status;
  StatusConectionChange(this.status);

  List<Object?> get props => [status];
}
