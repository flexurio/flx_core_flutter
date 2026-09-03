import 'package:file_picker/file_picker.dart';
import 'package:flx_core_flutter/src/app/util/save_file_io.dart'
    if (dart.library.html) 'package:flx_core_flutter/src/app/util/save_file_web.dart'
    as saver;

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
  saver.saveFile(bytes, filename);
}
