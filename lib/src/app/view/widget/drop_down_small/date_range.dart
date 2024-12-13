import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DropDownSmallDateRange extends StatefulWidget {
  const DropDownSmallDateRange({
    required this.labelText,
    required this.onChanged,
    this.initialValue,
    this.maxDate,
    super.key,
  });

  final String labelText;
  final DateTime? initialValue;
  final DateTime? maxDate;
  final void Function(DateTimeRange dateRange) onChanged;

  @override
  State<DropDownSmallDateRange> createState() => _DropDownSmallDateRangeState();
}

class _DropDownSmallDateRangeState extends State<DropDownSmallDateRange> {
  DateTimeRange? _selectedDateRange;
  String? value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue != null
        ? DateFormat.yMMMM().format(widget.initialValue!)
        : null;
  }

  void openDatePicker() {
    showDialog<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return SimpleDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 15,
          ),
          children: [
            SizedBox(
              height: 400,
              width: 300,
              child: DatePicker(
                // initialSelectedDate: _dateTimeSelected,
                maxDate: widget.maxDate,
                // minDate: widget.minDate,
                onChangeSingle: (value) {
                  // widget.controller.text = value.yMMMMd;
                  // widget.onChanged?.call(value);
                  // _dateTimeSelected = value;
                  // Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openDatePicker,
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
