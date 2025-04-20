import 'dart:collection';

import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/store/store.dart';

extension ListStoreMutate<T> on Mutator<ListStore<T>> {
  void add(T value) => unit._executeWithNotify((list) => list.add(value));
  void addAll(Iterable<T> values) => unit._executeWithNotify((list) => list.addAll(values));
  void insert(int index, T value) => unit._executeWithNotify((list) => list.insert(index, value));
  void remove(T value) => unit._executeWithNotify((list) => list.remove(value));
  void removeAt(int index) => unit._executeWithNotify((list) => list.removeAt(index));
  void shuffle() => unit._executeWithNotify((list) => list.shuffle());
}

base class ListStore<T> extends Store<List<T>> {
  ListStore(
    super.module,
    super.initialValue, {
    super.debugName,
  })  : _value = List.of(initialValue),
        super();

  @override
  late final List<T> value = UnmodifiableListView(_value);
  final List<T> _value;

  int get length => value.length;

  F _executeWithNotify<F>(F Function(List<T> list) callback) {
    final result = callback(_value);
    notifyUpdate(_value);
    return result;
  }
}
