class CompareDetails<T> {
  CompareDetails({
    required this.added,
    required this.changed,
    required this.removed,
  });

  final List<T> added;
  final List<T> changed;
  final List<T> removed;
}

CompareDetails<T> compareObject<T>({
  required List<T> initial,
  required List<T> data,
  required bool Function(T, T) keyMatch,
}) {
  final added = data.where((second) {
    return initial.indexWhere((first) => keyMatch(first, second)) == -1;
  }).toList();

  final removed = initial.where((first) {
    return data.indexWhere((second) => keyMatch(first, second)) == -1;
  }).toList();

  final changed = data.where((first) {
    return initial.indexWhere((second) => keyMatch(first, second)) > -1;
  }).toList();

  return CompareDetails<T>(
    added: added,
    changed: changed,
    removed: removed,
  );
}
