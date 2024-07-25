part of 'menu_bloc.dart';

class MenuState {
  const MenuState({
    required this.menu2Expanded,
    required this.menu3Selected,
    required this.home,
    required this.label,
  });
  final String menu2Expanded;
  final String menu3Selected;
  final Widget home;
  final String label;

  MenuState copyWith({
    String? menu2Expanded,
    String? menu3Selected,
    bool? isCollapsed,
    Widget? home,
    String? label,
  }) {
    return MenuState(
      menu2Expanded: menu2Expanded ?? this.menu2Expanded,
      menu3Selected: menu3Selected ?? this.menu3Selected,
      home: home ?? this.home,
      label: label ?? this.label,
    );
  }
}
