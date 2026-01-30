import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FieldDateWithMaskedTime extends StatefulWidget {
  const FieldDateWithMaskedTime({
    required this.dateController,
    required this.timeController,
    super.key,
    this.labelText,
    this.initialSelectedTime,
    this.onChanged,
    this.validator,
    this.minDate,
    this.maxDate,
  });

  final TextEditingController dateController;
  final TextEditingController timeController;
  final String? labelText;
  final DateTime? initialSelectedTime;
  final DateTime? minDate;
  final DateTime? maxDate;
  final void Function(DateTime value)? onChanged;
  final String? Function(DateTime?)? validator;

  @override
  State<FieldDateWithMaskedTime> createState() =>
      _FieldDateWithMaskedTimeState();
}

class _FieldDateWithMaskedTimeState extends State<FieldDateWithMaskedTime> {
  DateTime? _selectedDate;
  String? _errorText;

  final _dateFormat = DateFormat('MMMM dd, yyyy');

  @override
  void initState() {
    super.initState();

    if (widget.initialSelectedTime != null) {
      final dt = widget.initialSelectedTime!;
      _selectedDate = dt;
      widget.dateController.text = _dateFormat.format(dt);
      widget.timeController.text = DateFormat('HH:mm').format(dt);
    }
  }

  Future<void> _pickDate() async {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.minDate ?? DateTime(2000),
      lastDate: widget.maxDate ?? DateTime(2100),
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

    if (picked != null) {
      _selectedDate = picked;
      widget.dateController.text = _dateFormat.format(picked);
      _validateAndEmit();
      setState(() {});
    }
  }

  bool _isValidTime(String time) {
    if (time.length != 5 || !time.contains(':')) return false;
    final parts = time.split(':');
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    return h != null && m != null && h <= 23 && m <= 59;
  }

  DateTime? _composeDateTime() {
    if (_selectedDate == null) return null;
    if (!_isValidTime(widget.timeController.text)) return null;

    final parts = widget.timeController.text.split(':');
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  void _validateAndEmit() {
    final dateTime = _composeDateTime();

    if (_selectedDate != null && widget.timeController.text.isEmpty) {
      _errorText = 'Please fill in this field';
    } else if (_selectedDate == null && widget.timeController.text.isNotEmpty) {
      _errorText = 'Please fill in this field';
    } else if (widget.timeController.text.isNotEmpty &&
        !_isValidTime(widget.timeController.text)) {
      _errorText = 'Format time not valid';
    } else {
      _errorText = widget.validator?.call(dateTime);
    }

    if (_errorText == null && dateTime != null) {
      widget.onChanged?.call(dateTime);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const normalBorder = Color(0xFFE5E7EB);
    const errorBorder = Color(0xFFEF4444);
    const textColor = Color(0xFF111827);
    const hintColor = Color(0xFF9CA3AF);

    final hasError = _errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.labelText!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: textColor,
              ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 49,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasError ? errorBorder : normalBorder,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.dateController.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: widget.dateController.text.isEmpty
                          ? hintColor
                          : textColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 49,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasError ? errorBorder : normalBorder,
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: widget.timeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _TimeInputFormatter(),
                  ],
                  style: const TextStyle(fontSize: 15, color: textColor),
                  decoration: const InputDecoration(
                    hintText: '__:__',
                    hintStyle: TextStyle(color: hintColor),
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => _validateAndEmit(),
                ),
              ),
            ),
          ],
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              _errorText!,
              style: const TextStyle(
                fontSize: 12,
                color: errorBorder,
              ),
            ),
          ),
      ],
    );
  }
}

class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    String formatted;
    if (digits.length <= 2) {
      formatted = digits;
    } else {
      formatted = '${digits.substring(0, 2)}:${digits.substring(2)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
