Map<String, List<T>> groupBy<T>(List<T> items, String Function(T) group) {
  final data = <String, List<T>>{};
  for (final item in items) {
    final key = group(item);
    final keyExist = data.containsKey(key);
    if (keyExist) {
      data[key]!.add(item);
    } else {
      data[key] = [item];
    }
  }
  return data;
}

Map<String, T> groupByOne<T>(List<T> items, String Function(T) group) {
  final data = <String, T>{};
  for (final item in items) {
    final key = group(item);
    data[key] = item;
  }
  return data;
}
