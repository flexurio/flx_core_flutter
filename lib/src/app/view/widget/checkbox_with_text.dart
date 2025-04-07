import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FieldCheckBox extends StatelessWidget {
  const FieldCheckBox({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });
  final bool enabled;
  final bool initialValue;
  final String label;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: enabled ? null : Colors.blueGrey.shade100,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: CheckboxWithText(
        onChanged: onChanged,
        initialValue: initialValue,
        text: '$label${enabled ? '' : ' (Read Only)'}',
      ),
    );
  }
}

class CheckboxWithText extends StatefulWidget {
  const CheckboxWithText({
    required this.initialValue,
    required this.text,
    this.isProgress = false,
    super.key,
    this.onChanged,
    this.value,
  });
  final bool initialValue;
  final bool isProgress;
  final void Function(bool)? onChanged;
  final String text;
  final bool? value;

  @override
  State<CheckboxWithText> createState() => _CheckboxWithTextState();
}

class _CheckboxWithTextState extends State<CheckboxWithText> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: !widget.isProgress
              ? Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: WidgetStateBorderSide.resolveWith(
                    (states) => BorderSide(
                      color: _value ? primaryColor : Colors.grey.shade400,
                    ),
                  ),
                  value: widget.value ?? _value,
                  activeColor: primaryColor,
                  onChanged: (value) {
                    if (value != null) {
                      widget.onChanged?.call(value);
                      setState(() => _value = value);
                    }
                  },
                )
              : const CupertinoActivityIndicator(),
        ),
        const Gap(12),
        Expanded(child: Text(widget.text)),
      ],
    );
  }
}

class CheckboxWithText2 extends StatelessWidget {
  const CheckboxWithText2({
    required this.initialValue,
    required this.text,
    this.isProgress = false,
    super.key,
    this.onChanged,
  });
  final bool initialValue;
  final bool isProgress;
  final void Function(bool)? onChanged;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: !isProgress
              ? Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: WidgetStateBorderSide.resolveWith(
                    (states) => BorderSide(
                      color: initialValue ? primaryColor : Colors.grey.shade400,
                    ),
                  ),
                  value: initialValue,
                  activeColor: primaryColor,
                  onChanged: (value) {
                    if (value != null) {
                      onChanged?.call(value);
                    }
                  },
                )
              : const CupertinoActivityIndicator(),
        ),
        const Gap(12),
        Expanded(child: Text(text)),
      ],
    );
  }
}
