double stringDecimalToDouble(String string) {
  if (string == '' || string == '-') return 0;
  final number = double.parse(string.replaceAll(',', ''));
  return number;
}

int stringToInt(String string) {
  if (string == '') return 0;
  final number = int.parse(string.replaceAll(',', ''));
  return number;
}
