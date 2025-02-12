import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoolIcon extends StatelessWidget {
  const BoolIcon(this.value, {super.key});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Icon(
      value ? Icons.check_circle : Icons.cancel,
      color: value ? Colors.green : Colors.red,
    );
  }
}

class BoolSwitch extends StatelessWidget {
  const BoolSwitch(this.value, {super.key});

  final bool value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return CupertinoSwitch(
      value: value,
      onChanged: (_) {},
      activeTrackColor: primaryColor,
    );
  }
}
