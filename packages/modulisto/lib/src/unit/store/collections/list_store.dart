import 'dart:collection';

import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/store/store.dart';

/// Extension for mutating [ListStore] values via [Mutator].
extension ListStoreMutate<T> on Mutator<ListStore<T>> {
  /// Adds a value to the list.
  void add(T value) => unit._executeWithNotify((list) => list.add(value));

  /// Adds multiple values to the list.
  void addAll(Iterable<T> values) => unit._executeWithNotify((list) => list.addAll(values));

  /// Inserts a value at the specified index.
  void insert(int index, T value) => unit._executeWithNotify((list) => list.insert(index, value));

  /// Removes a value from the list.
  void remove(T value) => unit._executeWithNotify((list) => list.remove(value));

  /// Removes a value at the specified index.
  void removeAt(int index) => unit._executeWithNotify((list) => list.removeAt(index));

  /// Shuffles the list.
  void shuffle() => unit._executeWithNotify((list) => list.shuffle());
}

/// A [Store] that manages a list of values.
base class ListStore<T> extends Store<List<T>> {
  /// Creates a [ListStore] with an initial list and optional debug name.
  ListStore(
    super.module,
    super.initialValue, {
    super.debugName,
  })  : _value = List.of(initialValue),
        super();

  /// The current list value, exposed as an unmodifiable view.
  @override
  late final List<T> value = UnmodifiableListView(_value);
  final List<T> _value;

  /// The number of elements in the list.
  int get length => value.length;

  /// Executes a mutation on the list and notifies listeners.
  F _executeWithNotify<F>(F Function(List<T> list) callback) {
    final result = callback(_value);
    notifyUpdate(_value);
    return result;
  }
}
