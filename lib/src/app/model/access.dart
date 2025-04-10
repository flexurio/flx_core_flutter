import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Access {
  Access({
    required bool delete,
    required bool write,
    required bool read,
    required bool execute,
    required bool openClose,
    required bool export,
    required bool approveReject,
  }) : permissions = {
          'delete': delete,
          'write': write,
          'read': read,
          'execute': execute,
          'open_close': openClose,
          'export': export,
          'approve_reject': approveReject,
        };
  final Map<String, bool> permissions;

  int getValue() {
    return permissions.entries.fold<int>(0, (acc, entry) {
      final bit = {
        'delete': 1,
        'write': 2,
        'read': 4,
        'execute': 8,
        'open_close': 16,
        'export': 32,
        'approve_reject': 64,
      }[entry.key]!;
      return acc + (entry.value ? bit : 0);
    });
  }

  static const Map<String, Color> permissionColors = {
    'delete': Colors.red,
    'write': Colors.orange,
    'read': Colors.teal,
    'execute': Colors.blue,
    'open_close': Colors.purple,
    'export': Colors.green,
    'approve_reject': Colors.pink,
  };

  static Access fromValue(int value) {
    return Access(
      delete: (value & 1) != 0,
      write: (value & 2) != 0,
      read: (value & 4) != 0,
      execute: (value & 8) != 0,
      openClose: (value & 16) != 0,
      export: (value & 32) != 0,
      approveReject: (value & 64) != 0,
    );
  }

  static List<String> fetchPermissions(String role) {
    return role
        .split(',')
        .expand((permission) {
          final parts = permission.split('/');
          if (parts.length < 2) return [];
          final menu = parts[0];
          final action = int.tryParse(parts[1]) ?? 0;
          final access = fromValue(action);
          return access.permissions.entries
              .where((e) => e.value)
              .map((e) => '${menu}_${e.key}');
        })
        .toList()
        .cast();
  }

  Access copyWith({Map<String, bool>? updates}) {
    return Access(
      delete: updates?['delete'] ?? permissions['delete']!,
      write: updates?['write'] ?? permissions['write']!,
      read: updates?['read'] ?? permissions['read']!,
      execute: updates?['execute'] ?? permissions['execute']!,
      openClose: updates?['open_close'] ?? permissions['open_close']!,
      export: updates?['export'] ?? permissions['export']!,
      approveReject:
          updates?['approve_reject'] ?? permissions['approve_reject']!,
    );
  }
}

class FieldCheckboxPermission extends StatefulWidget {
  const FieldCheckboxPermission({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final Access initialValue;
  final void Function(Access) onChanged;

  @override
  State<FieldCheckboxPermission> createState() =>
      _FieldCheckboxPermissionState();
}

class _FieldCheckboxPermissionState extends State<FieldCheckboxPermission> {
  late Access _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _onChanged(String key, bool value) {
    _value = _value.copyWith(updates: {key: value});
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _value.permissions.entries.map((entry) {
        return Column(
          children: [
            FieldCheckBox(
              label: entry.key.tr(),
              initialValue: entry.value,
              onChanged: (value) => _onChanged(entry.key, value),
            ),
            const Gap(12),
          ],
        );
      }).toList(),
    );
  }
}
