import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/store/store.dart';

extension ListStoreMutate<T> on Mutator<ListStore<T>> {
  void add(T value) => target._executeWithNotify((list) => list.add(value));
  void addAll(Iterable<T> values) => target._executeWithNotify((list) => list.addAll(values));
  void insert(int index, T value) => target._executeWithNotify((list) => list.insert(index, value));
  void remove(T value) => target._executeWithNotify((list) => list.remove(value));
  void removeAt(int index) => target._executeWithNotify((list) => list.removeAt(index));
  void shuffle() => target._executeWithNotify((list) => list.shuffle());
}

base class ListStore<T> extends Store<Iterable<T>> {
  ListStore(
    super.module,
    super.initialValue, {
    super.debugName,
  })  : value = List.of(initialValue),
        super();

  @override
  final List<T> value;

  int get length => value.length;

  F _executeWithNotify<F>(F Function(List<T> xist) callback) {
    final result = callback(value);
    notifyUpdate(value);
    return result;
  }
}
