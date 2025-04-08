import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DropDownSmallDateRange extends StatefulWidget {
  const DropDownSmallDateRange({
    required this.labelText,
    required this.onChanged,
    this.initialValue,
    this.maxDate,
    this.minDate,
    super.key,
  });

  final String labelText;
  final PickerDateRange? initialValue;
  final DateTime? maxDate;
  final DateTime? minDate;
  final void Function(PickerDateRange dateRange) onChanged;

  @override
  State<DropDownSmallDateRange> createState() => _DropDownSmallDateRangeState();
}

class _DropDownSmallDateRangeState extends State<DropDownSmallDateRange> {
  PickerDateRange? _selectedDateRange;
  String? value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue != null
        ? '${widget.initialValue!.startDate?.ddMMyyyySlash} - ${widget.initialValue!.endDate?.ddMMyyyySlash}'
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
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedDateRange: _selectedDateRange,
                maxDate: widget.maxDate,
                minDate: widget.minDate,
                onChangeRange: (dates) {
                  if (dates.startDate == null || dates.endDate == null) return;
                  value =
                      '${dates.startDate?.ddMMyyyySlash} - '
                          '${dates.endDate?.ddMMyyyySlash}';
                  widget.onChanged.call(dates);
                  _selectedDateRange = dates;
                  setState(() {});
                },
              ),
            ),
            Button(
              color: theme.colorScheme.primary,
              isSecondary: true,
              action: DataAction.ok,
              permission: null,
              onPressed: () {
                Navigator.pop(context);
              },
            ).pullRight(),
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
