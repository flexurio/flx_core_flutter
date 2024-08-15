part of 'menu_bloc.dart';

class MenuState {
  const MenuState({
    required this.menu2Expanded,
    required this.menu3Selected,
    required this.home,
    required this.label,
    required this.triggerCloseDrawer,
  });
  final String menu2Expanded;
  final String menu3Selected;
  final Widget home;
  final String label;
  final bool triggerCloseDrawer;

  MenuState copyWith({
    String? menu2Expanded,
    String? menu3Selected,
    bool? isCollapsed,
    Widget? home,
    String? label,
    bool? triggerCloseDrawer,
  }) {
    return MenuState(
      menu2Expanded: menu2Expanded ?? this.menu2Expanded,
      menu3Selected: menu3Selected ?? this.menu3Selected,
      home: home ?? this.home,
      label: label ?? this.label,
      triggerCloseDrawer: triggerCloseDrawer ?? this.triggerCloseDrawer,
    );
  }
}
