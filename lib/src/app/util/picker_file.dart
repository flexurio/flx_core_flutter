// import 'dart:convert';
// import 'dart:html';

// import 'package:file_picker/file_picker.dart';

// Future<FilePickerResult?> pickFile({
//   List<String>? file,
//   FileType type = FileType.any,
//   bool allowedMultiple = false,
// }) async {
//   final result = await FilePicker.platform.pickFiles(
//     allowedExtensions: file,
//     type: type,
//     allowMultiple: allowedMultiple,
//   );
//   return result;
// }

// void saveFile(List<int> bytes, String filename) {
//   AnchorElement(
//     href:
//         'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}',
//   )
//     ..setAttribute('download', filename)
//     ..click();
// }

// -----------------------------------------------------------------------------

import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<FilePickerResult?> pickFile({
  List<String>? file,
  FileType type = FileType.any,
  bool allowedMultiple = false,
}) async {
  final result = await FilePicker.platform.pickFiles(
    allowedExtensions: file,
    type: type,
    allowMultiple: allowedMultiple,
  );
  return result;
}

void saveFile(List<int> bytes, String filename) {
  File(filename).writeAsBytes(bytes);
}
