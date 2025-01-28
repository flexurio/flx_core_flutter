import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class FieldYearPicker extends StatefulWidget {
  const FieldYearPicker({
    required this.enabled,
    required this.controller,
    required this.labelText,
    this.maxYear,
    this.minYear,
    this.errorText,
    this.initialYear,
    this.onChanged,
    this.validator,
    super.key,
  });

  final DateTime? maxYear;
  final bool enabled;
  final DateTime? minYear;
  final String? errorText;
  final String labelText;
  final int? initialYear;
  final TextEditingController controller;
  final void Function(int? year)? onChanged;
  final String? Function(String?)? validator;

  @override
  State<FieldYearPicker> createState() => _FieldYearPickerState();
}

class _FieldYearPickerState extends State<FieldYearPicker> {
  final _focusNode = FocusNode();
  late int? _yearSelected;

  void openDatePicker() {
    final theme = Theme.of(context);
    showDialog<int>(
      context: context,
      builder: (context) {
        final now = DateTime.now();
        return AlertDialog(
          backgroundColor: theme.cardColor,
          title: Text('period'.tr()),
          content: SizedBox(
            width: 400,
            height: 500,
            child: YearPicker(
              firstDate: widget.minYear ?? DateTime(2000),
              lastDate: widget.maxYear ?? DateTime(now.year + 40),
              selectedDate: DateTime(_yearSelected ?? now.year),
              onChanged: (DateTime date) {
                Navigator.pop(context, date.year);
              },
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        _yearSelected = value;
        widget.onChanged?.call(value);
        widget.controller.setText(_yearSelected.toString());
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _yearSelected = widget.initialYear;
    if (_yearSelected != null) {
      widget.controller.setText(_yearSelected.toString());
    }
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        openDatePicker();
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FieldText(
      enabled: widget.enabled,
      focusNode: _focusNode,
      labelText: widget.labelText,
      errorText: widget.errorText,
      controller: widget.controller,
      validator: (_) => widget.validator?.call(_yearSelected.toString()),
    );
  }
}
