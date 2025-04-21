import 'dart:collection';

import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/store/store.dart';

extension MapStoreMutate<K, V> on Mutator<MapStore<K, V>> {
  void setKeyValue(K key, V value) => unit._executeWithNotify((map) => map[key] = value);
  void addAll(Map<K, V> values) => unit._executeWithNotify((map) => map.addAll(values));
  void remove(K key) => unit._executeWithNotify((map) => map.remove(key));
  void removeWhere(bool Function(K, V) test) =>
      unit._executeWithNotify((map) => map.removeWhere(test));

  void clear() => unit._executeWithNotify((map) => map.clear());
}

base class MapStore<K, V> extends Store<Map<K, V>> {
  MapStore(
    super.module,
    super.initialValue, {
    super.debugName,
  })  : _value = Map.of(initialValue),
        super();

  @override
  late final Map<K, V> value = UnmodifiableMapView(_value);
  final Map<K, V> _value;

  V? operator [](Object? key) => this._value[key];

  Iterable<K> get keys => value.keys;

  T _executeWithNotify<T>(T Function(Map<K, V> map) callback) {
    final result = callback(_value);
    notifyUpdate(_value);
    return result;
  }
}
