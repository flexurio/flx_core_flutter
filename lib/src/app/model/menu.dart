import 'package:flutter/material.dart';

class Menu1 {
  Menu1({
    required this.label,
    required this.menu,
  });

  final String label;
  final List<Menu2> menu;
}

class Menu2 {
  Menu2({
    required this.label,
    required this.icon,
    required this.menu,
    this.labelShort,
  });
  final String label;
  final String? labelShort;
  final IconData icon;
  final List<Menu3> menu;
}

class Menu3 {
  Menu3({
    required this.label,
    required this.home,
    required this.permissions,
    required this.permission,
  });
  final String label;
  final Widget home;
  final String? permission;
  final List<String> permissions;
}
