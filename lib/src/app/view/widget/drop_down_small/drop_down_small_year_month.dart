import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DropDownSmallYearMonth extends StatefulWidget {
  const DropDownSmallYearMonth({
    required this.labelText,
    required this.onChanged,
    this.initialValue,
    this.maxDate,
    super.key,
  });

  final String labelText;
  final DateTime? initialValue;
  final DateTime? maxDate;
  final void Function(DateTime date) onChanged;

  @override
  State<DropDownSmallYearMonth> createState() => _DropDownSmallYearMonthState();
}

class _DropDownSmallYearMonthState extends State<DropDownSmallYearMonth> {
  String? value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue != null
        ? DateFormat.yMMMM().format(widget.initialValue!)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final theme = Theme.of(context);
        final primaryColor = theme.colorScheme.primary;
        showMonthPicker(
          lastDate: widget.maxDate,
          context: context,
          headerColor: primaryColor,
          selectedMonthBackgroundColor: primaryColor.lighten(.3),
          selectedMonthTextColor: primaryColor,
          initialDate: DateTime.now(),
          dismissible: true,
        ).then((date) {
          if (date != null) {
            value = DateFormat.yMMMM().format(date);
            widget.onChanged.call(date);
            setState(() {});
          }
        });
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
