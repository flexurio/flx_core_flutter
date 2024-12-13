// import 'package:easy_localization/easy_localization.dart';
// import 'package:flexurio_erp_core/flexurio_erp_core.dart';
// import 'package:flutter/material.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';

// class DropDownSmallYearMonth extends StatefulWidget {
//   const DropDownSmallYearMonth({
//     required this.labelText,
//     required this.onChanged,
//     this.initialValue,
//     this.maxDate,
//     super.key,
//   });

//   final String labelText;
//   final DateTime? initialValue;
//   final DateTime? maxDate;
//   final void Function(DateTime date) onChanged;

//   @override
//   State<DropDownSmallYearMonth> createState() => _DropDownSmallYearMonthState();
// }

// class _DropDownSmallYearMonthState extends State<DropDownSmallYearMonth> {
//   String? value;

//   @override
//   void initState() {
//     super.initState();
//     value = widget.initialValue != null
//         ? DateFormat.yMMMM().format(widget.initialValue!)
//         : null;
//   }

//   void openDatePicker() {
//     showDialog<void>(
//       context: context,
//       builder: (context) {
//         final theme = Theme.of(context);
//         return SimpleDialog(
//           backgroundColor: theme.cardColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           contentPadding: const EdgeInsets.only(
//             left: 15,
//             right: 15,
//             bottom: 15,
//           ),
//           children: [
//             SizedBox(
//               height: 400,
//               width: 300,
//               child: DatePicker(
//                 initialSelectedDate: _dateTimeSelected,
//                 maxDate: widget.maxDate,
//                 minDate: widget.minDate,
//                 onChange: (value) {
//                   widget.controller.text = value.yMMMMd;
//                   widget.onChanged?.call(value);
//                   _dateTimeSelected = value;
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         openDatePicker();
//       },
//       child: AbsorbPointer(
//         child: DropDownSmall(
//           key: ValueKey(value),
//           icon: Icons.calendar_month,
//           labelText: widget.labelText,
//           initialValue: value,
//           itemAsString: (_) => value ?? '',
//           items: [value],
//           onChanged: (_) {},
//         ),
//       ),
//     );
//   }
// }

// class DropDownSmallDate extends StatefulWidget {
//   const DropDownSmallDate({
//     required this.labelText,
//     required this.onChanged,
//     this.initialValue,
//     this.maxDate,
//     super.key,
//   });

//   final String labelText;
//   final DateTime? initialValue;
//   final DateTime? maxDate;
//   final void Function(DateTime date) onChanged;

//   @override
//   State<DropDownSmallDate> createState() => _DropDownSmallDateState();
// }

// class _DropDownSmallDateState extends State<DropDownSmallDate> {
//   DateTime? _dateTimeSelected;

//   @override
//   void initState() {
//     super.initState();
//     _dateTimeSelected = widget.initialValue;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final value = _dateTimeSelected != null
//         ? DateFormat.yMMMMd().format(_dateTimeSelected!)
//         : null;
//     return InkWell(
//       onTap: () {
//         showDialog<void>(
//           context: context,
//           builder: (context) {
//             final theme = Theme.of(context);
//             return SimpleDialog(
//               backgroundColor: theme.cardColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               contentPadding: const EdgeInsets.only(
//                 left: 15,
//                 right: 15,
//                 bottom: 15,
//               ),
//               children: [
//                 SizedBox(
//                   height: 400,
//                   width: 300,
//                   child: DatePicker(
//                     initialSelectedDate: _dateTimeSelected,
//                     maxDate: widget.maxDate,
//                     onChange: (date) {
//                       widget.onChanged.call(date);
//                       _dateTimeSelected = date;
//                       setState(() {});
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//       child: AbsorbPointer(
//         child: DropDownSmall(
//           key: ValueKey(_dateTimeSelected),
//           icon: Icons.calendar_month,
//           labelText: widget.labelText,
//           initialValue: value,
//           itemAsString: (_) => value ?? '',
//           items: [value ?? ''],
//           onChanged: (_) {},
//         ),
//       ),
//     );
//   }
// }
