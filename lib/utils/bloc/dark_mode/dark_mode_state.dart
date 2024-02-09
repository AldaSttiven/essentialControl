part of 'dark_mode_bloc.dart';

class DarkModeState extends Equatable{
  const DarkModeState();
  
  @override
  List<Object?> get props => [];
}

class darkModeInitial extends DarkModeState{}

class darkModeDark extends DarkModeState{}

class darkModeLight extends DarkModeState{}
