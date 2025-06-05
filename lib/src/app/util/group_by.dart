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

/// Returns the total sum of a numeric field from a list of objects.
///
/// This is a generic utility function that iterates over a list of type [T]
/// and calculates the sum of values extracted by the provided [field] function.
///
/// Example:
/// ```dart
/// class Order {
///   final int quantity;
///   Order(this.quantity);
/// }
///
/// final orders = [Order(2), Order(3), Order(5)];
/// final totalQuantity = sum<Order>(orders, (o) => o.quantity); // 10
/// ```
///
/// - [items]: The list of objects to sum.
/// - [field]: A function that extracts the numeric value from each object.
///
/// Returns the sum as a [num], which may be an [int] or [double]
/// depending on the values returned by [field].
num sum<T>(List<T> items, num Function(T) field) => items.fold<num>(
      0,
      (sum, item) => sum + field(item),
    );

Map<String, T> groupByOne<T>(List<T> items, String Function(T) group) {
  final data = <String, T>{};
  for (final item in items) {
    final key = group(item);
    data[key] = item;
  }
  return data;
}
