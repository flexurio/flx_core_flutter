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

extension IterableSumExtension<T> on Iterable<T> {
  num sum(num Function(T) selector) {
    return map(selector).fold(0, (a, b) => a + b);
  }
}

Map<String, T> groupByOne<T>(List<T> items, String Function(T) group) {
  final data = <String, T>{};
  for (final item in items) {
    final key = group(item);
    data[key] = item;
  }
  return data;
}
