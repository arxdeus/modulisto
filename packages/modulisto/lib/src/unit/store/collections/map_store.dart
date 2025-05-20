import 'dart:collection';

import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/store/store.dart';

/// Extension for mutating [MapStore] values via [Mutator].
extension MapStoreMutate<K, V> on Mutator<MapStore<K, V>> {
  /// Sets a key-value pair in the map.
  void setKeyValue(K key, V value) => unit._executeWithNotify((map) => map[key] = value);

  /// Adds all key-value pairs from another map.
  void addAll(Map<K, V> values) => unit._executeWithNotify((map) => map.addAll(values));

  /// Removes a key from the map.
  void remove(K key) => unit._executeWithNotify((map) => map.remove(key));

  /// Removes entries that satisfy the given test.
  void removeWhere(bool Function(K, V) test) =>
      unit._executeWithNotify((map) => map.removeWhere(test));

  /// Clears all entries from the map.
  void clear() => unit._executeWithNotify((map) => map.clear());
}

/// A [Store] that manages a map of key-value pairs.
base class MapStore<K, V> extends Store<Map<K, V>> {
  /// Creates a [MapStore] with an initial map and optional debug name.
  MapStore(
    super.module,
    super.initialValue, {
    super.debugName,
  })  : _value = Map.of(initialValue),
        super();

  /// The current map value, exposed as an unmodifiable view.
  @override
  late final Map<K, V> value = UnmodifiableMapView(_value);
  final Map<K, V> _value;

  /// Returns the value for the given key, or null if not present.
  V? operator [](Object? key) => this._value[key];

  /// The keys in the map.
  Iterable<K> get keys => value.keys;

  /// Executes a mutation on the map and notifies listeners.
  T _executeWithNotify<T>(T Function(Map<K, V> map) callback) {
    final result = callback(_value);
    notifyUpdate(_value);
    return result;
  }
}
