extension ListExtension<T> on List<T> {
  List<T> distinct(String Function(T) key) {
    final uniqueKey = <String>[];
    final unique = <T>[];
    for (final e in this) {
      if (!uniqueKey.contains(key(e))) {
        unique.add(e);
        uniqueKey.add(key(e));
      }
    }
    return unique;
  }
}
