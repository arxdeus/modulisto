import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/store/store.dart';

extension MapStoreMutate<K, V> on Mutator<MapStore<K, V>> {
  void setValue(K key, V value) => target._executeWithNotify((map) => map[key] = value);
  void addAll(Map<K, V> values) => target._executeWithNotify((map) => map.addAll(values));
  void remove(K key) => target._executeWithNotify((map) => map.remove(key));
  void removeWhere(bool Function(K, V) test) =>
      target._executeWithNotify((map) => map.removeWhere(test));

  void clear() => target._executeWithNotify((map) => map.clear());
}

base class MapStore<K, V> extends Store<Map<K, V>> {
  MapStore(
    super.module,
    super.initialValue, {
    super.debugName,
  })  : value = Map.of(initialValue),
        super();

  @override
  final Map<K, V> value;

  V? operator [](Object? key) => this.value[key];

  Iterable<K> get keys => value.keys;

  T _executeWithNotify<T>(T Function(Map<K, V> map) callback) {
    final result = callback(value);
    notifyUpdate(value);
    return result;
  }
}
