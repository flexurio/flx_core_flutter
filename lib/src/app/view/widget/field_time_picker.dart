import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class FieldTimePicker extends StatefulWidget {
  const FieldTimePicker({
    required this.labelText,
    required this.controller,
    super.key,
    this.onChanged,
    this.initialSelectedTime,
    this.validator,
    this.enabled = true,
  });

  final bool enabled;
  final String labelText;
  final DateTime? initialSelectedTime;
  final TextEditingController controller;
  final void Function(DateTime value)? onChanged;
  final String? Function(DateTime?)? validator;

  @override
  State<FieldTimePicker> createState() => _FieldTimePickerState();
}

class _FieldTimePickerState extends State<FieldTimePicker> {
  final focusNode = FocusNode();
  late DateTime? _timeSelected;

  @override
  void initState() {
    super.initState();
    _timeSelected = widget.initialSelectedTime;
    if (_timeSelected != null) {
      widget.controller.setText(_timeSelected!.yMMMdHm);
    }
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _openTimePicker();
        focusNode.unfocus();
      }
    });
  }

  Future<void> _openTimePicker() async {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final selectedDate = await showDatePicker(
      initialDate: widget.initialSelectedTime,
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      confirmText: 'Apply',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              surfaceTint: Colors.white,
              secondary: primaryColor.withOpacity(0.4),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          widget.initialSelectedTime ?? DateTime.now(),
        ),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor,
                surfaceTint: Colors.white,
                secondary: primaryColor.withOpacity(0.4),
              ),
            ),
            child: child!,
          );
        },
      );

      if (selectedTime != null) {
        final selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          _timeSelected = selectedDateTime;
          widget.controller.text = _timeSelected!.yMMMdHm;
        });

        widget.onChanged?.call(_timeSelected!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FieldText(
      enabled: widget.enabled,
      focusNode: focusNode,
      controller: widget.controller,
      labelText: widget.labelText,
      validator: (_) => widget.validator?.call(_timeSelected),
    );
  }
}
