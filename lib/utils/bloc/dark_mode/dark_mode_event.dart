  part of 'dark_mode_bloc.dart';

  abstract class DarkModeEvent extends Equatable{
    @override
    List<Object?> get props => [];
  }

  class DarkModeInitial extends DarkModeEvent{}

  class DarkModeChange extends DarkModeEvent{}
