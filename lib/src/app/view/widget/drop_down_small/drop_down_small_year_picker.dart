import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flx_core_flutter/flx_core_flutter.dart';

class DropDownSmallYearPicker extends StatefulWidget {
  const DropDownSmallYearPicker({
    required this.labelText,
    required this.onChanged,
    super.key,
    this.initialValue,
    this.maxDate,
    this.minDate,
  });

  final String labelText;
  final int? initialValue;
  final DateTime? maxDate;
  final DateTime? minDate;
  final void Function(int year) onChanged;

  @override
  State<DropDownSmallYearPicker> createState() =>
      _DropDownSmallYearPickerState();
}

class _DropDownSmallYearPickerState extends State<DropDownSmallYearPicker> {
  String? value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue?.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () async {
        final year = await showDialog<int>(
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
                  firstDate: widget.minDate ?? DateTime(2000),
                  lastDate: widget.maxDate ?? DateTime(now.year + 40),
                  selectedDate: DateTime(widget.initialValue ?? now.year),
                  onChanged: (DateTime date) {
                    Navigator.pop(context, date.year);
                  },
                ),
              ),
            );
          },
        );
        if (year != null) {
          value = year.toString();
          widget.onChanged.call(year);
          setState(() {});
        }
      },
      child: AbsorbPointer(
        child: DropDownSmall(
          key: ValueKey(value),
          icon: Icons.calendar_month,
          labelText: widget.labelText,
          initialValue: value,
          itemAsString: (_) => value ?? '',
          items: [value],
          onChanged: (_) {},
        ),
      ),
    );
  }
}
