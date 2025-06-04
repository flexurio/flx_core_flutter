import 'dart:convert';

Map<String, dynamic> base64ToMap(String text) {
  final decodedPayload = base64Url.decode(base64.normalize(text.trim()));
  return jsonDecode(utf8.decode(decodedPayload)) as Map<String, dynamic>;
}
