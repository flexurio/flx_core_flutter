import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class VisibilityPermission extends StatelessWidget {
  const VisibilityPermission({
    required this.permission,
    required this.child,
    this.orElse,
    super.key,
  });

  final List<String>? permission;
  final Widget child;
  final Widget? orElse;

  Future<List<String>> _loadPermissions() async {
    if (permission == null) return [];
    final userRepository = await Hive.openBox<dynamic>('user_repository');
    final perms = userRepository.get('permission');
    return (perms is List) ? List<String>.from(perms) : [];
  }

  @override
  Widget build(BuildContext context) {
    if (permission == null) {
      return child;
    }

    return FutureBuilder<List<String>>(
      future: _loadPermissions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return orElse ?? const SizedBox.shrink();
        }

        final userPermissions = snapshot.data!;
        final hasPermission = permission!.any(userPermissions.contains);
        print(
          '[VisibilityPermission] permission: $permission, hasPermission: $hasPermission',
        );

        if (orElse != null) {
          return hasPermission ? child : orElse!;
        }

        return Visibility(
          visible: hasPermission,
          child: child,
        );
      },
    );
  }
}

class VisibilityPermissionBuilder extends StatelessWidget {
  const VisibilityPermissionBuilder({
    required this.permission,
    required this.builder,
    super.key,
  });

  final List<String>? permission;
  final Widget Function(bool visible) builder;

  Future<List<String>> _loadPermissions() async {
    if (permission == null) return [];
    final userRepository = await Hive.openBox<dynamic>('user_repository');
    final perms = userRepository.get('permission');
    return (perms is List) ? List<String>.from(perms) : [];
  }

  @override
  Widget build(BuildContext context) {
    if (permission == null) {
      return builder(true);
    }

    return FutureBuilder<List<String>>(
      future: _loadPermissions(),
      builder: (context, snapshot) {
        final perms = snapshot.data ?? [];
        final isVisible = permission!.any(perms.contains);
        return builder(isVisible);
      },
    );
  }
}
