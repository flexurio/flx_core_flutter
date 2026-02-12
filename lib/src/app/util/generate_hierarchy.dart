class TreeItem<T> {
  TreeItem({required this.item, required this.children});
  T item;
  Iterable<TreeItem<T>> children;
}

Iterable<TreeItem<T>> generateTree<T, K>(
  Iterable<T> collection,
  K Function(T) idSelector,
  K Function(T) parentIdSelector, {
  K? rootId,
}) sync* {
  for (final c in collection.where((c) => parentIdSelector(c) == rootId)) {
    yield TreeItem<T>(
      item: c,
      children: generateTree(
        collection,
        idSelector,
        parentIdSelector,
        rootId: idSelector(c),
      ),
    );
  }
}
