// ignore_for_file: avoid_positional_boolean_parameters

List<T> sortString<T>(List<T> data, String Function(T) field, bool ascending) {
  if (ascending) {
    return List.from(data)..sort((a, b) => field(a).compareTo(field(b)));
  } else {
    return List.from(data)..sort((a, b) => field(b).compareTo(field(a)));
  }
}

List<T> sortNum<T>(List<T> data, num Function(T) field, bool ascending) {
  if (ascending) {
    return List.from(data)..sort((a, b) => field(a).compareTo(field(b)));
  } else {
    return List.from(data)..sort((a, b) => field(b).compareTo(field(a)));
  }
}
