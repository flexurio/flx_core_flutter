abstract class DropDownObject<T> {
  T? get initialValue;
  void Function(T? value) get onChanged;
  bool get isRequired;
  bool get enabled;
  String? get label;
}
