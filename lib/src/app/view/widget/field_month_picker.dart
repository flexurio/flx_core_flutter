import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class FieldMonthPicker extends StatefulWidget {
  const FieldMonthPicker({
    required this.maxDate,
    required this.labelText,
    required this.controller,
    super.key,
    this.onChanged,
    this.initialSelectedDate,
    this.minDate,
    this.validator,
    this.isRequired = true,
    this.errorText,
  });
  final bool isRequired;
  final DateTime maxDate;
  final DateTime? minDate;
  final String? errorText;
  final String labelText;
  final DateTime? initialSelectedDate;
  final TextEditingController controller;
  final void Function(DateTime value)? onChanged;
  final String? Function(DateTime?)? validator;

  @override
  State<FieldMonthPicker> createState() => _FieldMonthPickerState();
}

class _FieldMonthPickerState extends State<FieldMonthPicker> {
  final focusNode = FocusNode();
  late DateTime? _dateTimeSelected;

  @override
  void initState() {
    super.initState();
    _dateTimeSelected = widget.initialSelectedDate;
    if (_dateTimeSelected != null) {
      widget.controller.text = DateFormat.yMMMM().format(_dateTimeSelected!);
    }
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _openMonthPicker(context);
        focusNode.unfocus();
      }
    });
  }

  void _openMonthPicker(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    showMonthPicker(
      context: context,
      headerColor: primaryColor,
      selectedMonthBackgroundColor: primaryColor.lighten(.3),
      selectedMonthTextColor: primaryColor,
      initialDate: DateTime.now(),
      dismissible: true,
    ).then((date) {
      if (date != null) {
        widget.controller.text = DateFormat.yMMMM().format(date);
        widget.onChanged?.call(date);
        _dateTimeSelected = date;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FieldText(
      focusNode: focusNode,
      labelText: widget.labelText,
      errorText: widget.errorText,
      controller: widget.controller,
      validator: (_) => widget.validator?.call(_dateTimeSelected),
    );
  }
}
