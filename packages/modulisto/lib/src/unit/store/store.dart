import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/store/value_unit_base.dart';

extension StoreMutate<T> on Mutator<Store<T>> {
  void set(T value) => unit.update(value);
  void patch(T Function(T oldValue) buildValue) => unit.update(
        buildValue(unit.value),
      );
}

/// A subtype of the [Unit] that represents a holder/storage/container for [T] [value]
base class Store<T> extends ValueUnitBase<T> implements Mutable {
  Store(
    super.module,
    T initialValue, {
    super.debugName,
  })  : _value = initialValue,
        super();

  @internal
  void update(T newValue) {
    _value = newValue;
    notifyUpdate(newValue);
  }

  @override
  T get value => _value;

  T _value;

  @override
  @internal
  @protected
  void dispose() => super.dispose();

  @override
  String toString() => 'Store(debugName: $debugName, value: $value, module: ${$module})';
}
