import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/store/value_unit_base.dart';

/// Extension for mutating [Store] values via [Mutator]
extension StoreMutate<T> on Mutator<Store<T>> {
  /// Sets the value of the store
  void set(T value) => unit.update(value);

  /// Updates the value of the store using a builder function
  void patch(T Function(T oldValue) buildValue) => unit.update(
        buildValue(unit.value),
      );
}

/// A subtype of the [Unit] that represents a holder/storage/container for [T] [value]
base class Store<T> extends ValueUnitBase<T> implements Mutable {
  /// Creates a [Store] with an initial value and optional debug name.
  Store(
    super.module,
    T initialValue, {
    super.debugName,
  })  : _value = initialValue,
        super();

  @internal

  /// Updates the value and notifies listeners.
  void update(T newValue) {
    _value = newValue;
    notifyUpdate(newValue);
  }

  /// The current value held by the store.
  @override
  T get value => _value;

  T _value;

  @override
  @internal
  @protected

  /// Disposes the store and its listeners.
  void dispose() => super.dispose();

  @override
  String toString() => 'Store(debugName: $debugName, value: $value, module: ${$module})';
}
