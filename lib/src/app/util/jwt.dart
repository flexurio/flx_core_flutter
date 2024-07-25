import 'dart:convert';

Map<String, dynamic> extractPayloadFromJwt(String jwt) {
  final parts = jwt.split('.');
  if (parts.length != 3) {
    throw ArgumentError();
  }

  final payload = parts[1];
  return base64ToMap(payload);
}

Map<String, dynamic> base64ToMap(String text) {
  final decodedPayload = base64Url.decode(base64.normalize(text.trim()));
  return jsonDecode(utf8.decode(decodedPayload)) as Map<String, dynamic>;
}
