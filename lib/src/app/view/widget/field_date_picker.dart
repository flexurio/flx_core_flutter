import 'package:flexurio_erp_core/flexurio_erp_core.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FieldDatePicker extends StatefulWidget {
  const FieldDatePicker({
    required this.labelText,
    required this.controller,
    super.key,
    this.maxDate,
    this.onChanged,
    this.initialSelectedDate,
    this.minDate,
    this.validator,
    this.errorText,
    this.enabled = true,
  });
  final DateTime? maxDate;
  final bool enabled;
  final DateTime? minDate;
  final String? errorText;
  final String labelText;
  final DateTime? initialSelectedDate;
  final TextEditingController controller;
  final void Function(DateTime value)? onChanged;
  final String? Function(DateTime?)? validator;

  @override
  State<FieldDatePicker> createState() => _FieldDatePickerState();
}

class _FieldDatePickerState extends State<FieldDatePicker> {
  final _focusNode = FocusNode();
  late DateTime? _dateTimeSelected;

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
                initialSelectedDate: _dateTimeSelected,
                maxDate: widget.maxDate,
                minDate: widget.minDate,
                onChangeSingle: (value) {
                  widget.controller.text = value.yMMMMd;
                  widget.onChanged?.call(value);
                  _dateTimeSelected = value;
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _dateTimeSelected = widget.initialSelectedDate;
    if (_dateTimeSelected != null) {
      widget.controller.setText(_dateTimeSelected!.yMMMMd);
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
      validator: (_) => widget.validator?.call(_dateTimeSelected),
    );
  }
}

class DatePicker extends StatelessWidget {
  const DatePicker({
    this.onChangeSingle,
    super.key,
    this.maxDate,
    this.initialSelectedDate,
    this.initialSelectedDateRange,
    this.minDate,
    this.selectionMode = DateRangePickerSelectionMode.single,
    this.onChangeRange,
  });
  final DateTime? maxDate;
  final DateTime? minDate;
  final PickerDateRange? initialSelectedDateRange;
  final DateTime? initialSelectedDate;
  final void Function(DateTime value)? onChangeSingle;
  final void Function(PickerDateRange value)? onChangeRange;
  final DateRangePickerSelectionMode selectionMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final monthCellBackground =
        isDark ? const Color(0xFF232731) : Colors.blue[100]!.withOpacity(.3);
    final indicatorColor = theme.colorScheme.secondary;
    final highlightColor = theme.colorScheme.primary;
    final cellTextColor = isDark ? Colors.white70 : const Color(0xFF130438);

    return SfDateRangePicker(
      selectionMode: selectionMode,
      selectionShape: DateRangePickerSelectionShape.rectangle,
      selectionColor: highlightColor,
      selectionTextStyle: TextStyle(
        color: isDark ? Colors.black : Colors.white,
        fontSize: 14,
      ),
      backgroundColor: theme.cardColor,
      minDate: minDate,
      maxDate: maxDate,
      headerHeight: 70,
      headerStyle: DateRangePickerHeaderStyle(
        backgroundColor: theme.cardColor,
        textAlign: TextAlign.center,
        textStyle: TextStyle(
          fontSize: 18,
          color: cellTextColor,
        ),
      ),
      onSelectionChanged: (args) {
        if (args.value is DateTime) {
          final selectedDate = args.value as DateTime;
          onChangeSingle?.call(selectedDate);
        } else if (args.value is PickerDateRange) {
          final selectedRange = args.value as PickerDateRange;
          onChangeRange?.call(selectedRange);
        }
      },
      initialSelectedDate: initialSelectedDate,
      rangeSelectionColor: theme.colorScheme.primary.withOpacity(.4),
      monthCellStyle: DateRangePickerMonthCellStyle(
        cellDecoration: _MonthCellDecoration(
          borderColor: Colors.red,
          backgroundColor: monthCellBackground,
          showIndicator: false,
          indicatorColor: indicatorColor,
        ),
        todayCellDecoration: _MonthCellDecoration(
          borderColor: highlightColor,
          backgroundColor: monthCellBackground,
          showIndicator: false,
          indicatorColor: indicatorColor,
        ),
        specialDatesDecoration: _MonthCellDecoration(
          borderColor: Colors.red,
          backgroundColor: monthCellBackground,
          showIndicator: true,
          indicatorColor: indicatorColor,
        ),
        disabledDatesTextStyle: TextStyle(
          color: isDark ? const Color(0xFF666479) : Colors.blue[100],
        ),
        weekendTextStyle: TextStyle(color: highlightColor),
        textStyle: TextStyle(color: cellTextColor, fontSize: 14),
        specialDatesTextStyle: TextStyle(color: cellTextColor, fontSize: 14),
        todayTextStyle: TextStyle(color: highlightColor, fontSize: 14),
      ),
      yearCellStyle: DateRangePickerYearCellStyle(
        todayTextStyle: TextStyle(color: highlightColor, fontSize: 14),
        textStyle: TextStyle(color: cellTextColor, fontSize: 14),
        disabledDatesTextStyle: TextStyle(
          color: isDark ? const Color(0xFF666479) : const Color(0xffe2d7fe),
        ),
        leadingDatesTextStyle:
            TextStyle(color: cellTextColor.withOpacity(0.5), fontSize: 14),
      ),
      showNavigationArrow: true,
      todayHighlightColor: highlightColor,
      monthViewSettings: DateRangePickerMonthViewSettings(
        firstDayOfWeek: 1,
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: TextStyle(
            fontSize: 10,
            color: cellTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        dayFormat: 'EEE',
      ),
    );
  }
}

class _MonthCellDecoration extends Decoration {
  const _MonthCellDecoration({
    required this.borderColor,
    required this.backgroundColor,
    required this.showIndicator,
    required this.indicatorColor,
  });

  final Color borderColor;
  final Color backgroundColor;
  final bool showIndicator;
  final Color indicatorColor;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MonthCellDecorationPainter(
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      showIndicator: showIndicator,
      indicatorColor: indicatorColor,
    );
  }
}

class _MonthCellDecorationPainter extends BoxPainter {
  _MonthCellDecorationPainter({
    required this.borderColor,
    required this.backgroundColor,
    required this.showIndicator,
    required this.indicatorColor,
  });

  final Color borderColor;
  final Color backgroundColor;
  final bool showIndicator;
  final Color indicatorColor;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final bounds = offset & (configuration.size ?? Size.zero);
    _drawDecoration(canvas, bounds);
  }

  void _drawDecoration(Canvas canvas, Rect bounds) {
    final paint = Paint()..color = backgroundColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(bounds, const Radius.circular(5)),
      paint,
    );
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    if (showIndicator) {
      paint
        ..color = indicatorColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(bounds.right - 6, bounds.top + 6), 2.5, paint);
    }
  }
}
