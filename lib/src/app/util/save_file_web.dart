import 'dart:convert';
import 'dart:html';

void saveFile(List<int> bytes, String filename) {
  AnchorElement(
    href:
        'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}',
  )
    ..setAttribute('download', filename)
    ..click();
}
