import 'package:flutter/material.dart';

class Menu1 {
  Menu1({
    required this.menu,
    this.label,
  });

  final String? label;
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
    @Deprecated('Use permissionProvider instead') this.permissions = const [],
    this.permission,
    this.permissionProvider,
  });
  final String label;
  final Widget home;
  final String? permission;
  @Deprecated('Use permissionProvider instead')
  final List<String> permissions;
  final Future<List<String>> Function()? permissionProvider;
}
