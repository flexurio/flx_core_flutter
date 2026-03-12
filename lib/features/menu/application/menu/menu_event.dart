part of 'menu_bloc.dart';

@immutable
abstract class MenuEvent {}

class Menu2Expanded extends MenuEvent {
  Menu2Expanded(this.key);
  final String key;
}

class Menu3Selected extends MenuEvent {
  Menu3Selected({
    required this.home,
    required this.label,
  });
  final String label;
  final Widget home;
}
