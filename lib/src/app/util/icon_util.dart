import 'package:flutter/material.dart';

const Map<String, IconData> commonIcons = {
  'Add': Icons.add,
  'Edit': Icons.edit,
  'Delete': Icons.delete,
  'Print': Icons.print,
  'Save': Icons.save,
  'Search': Icons.search,
  'Refresh': Icons.refresh,
  'Home': Icons.home,
  'Settings': Icons.settings,
  'Table': Icons.table_chart,
  'List': Icons.list,
  'Visibility': Icons.visibility,
  'Upload': Icons.file_upload,
  'Download': Icons.file_download,
  'Check': Icons.check,
  'Close': Icons.close,
  'Info': Icons.info,
  'Warning': Icons.warning,
  'Error': Icons.error,
  'Open in New': Icons.open_in_new,
  'Launch': Icons.launch,
  'Touch App': Icons.touch_app,
  'Person': Icons.person,
  'Email': Icons.email,
  'Phone': Icons.phone,
  'Location': Icons.location_on,
  'Date': Icons.calendar_today,
  'Time': Icons.access_time,
};

IconData getIconByName(String? name) {
  if (name == null) return Icons.touch_app_outlined;
  return commonIcons[name] ?? Icons.touch_app_outlined;
}
