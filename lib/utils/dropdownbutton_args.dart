class DropDownButtonArgs<T> {
  T value;
  List<T> items;
  Function(T) callback;
  DropDownButtonArgs({
    required this.value,
    required this.items,
    required this.callback,
  });
}
