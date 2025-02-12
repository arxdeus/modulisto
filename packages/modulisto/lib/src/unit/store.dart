import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/unit/unit.dart';

final class Store<T> extends UnitImpl<T> {
  T _value;
  T get value => _value;
  Store(
    super.module,
    this._value, {
    super.debugName,
  });

  void _update(T newValue) {
    _value = newValue;
    notifyUpdate(newValue);
  }

  @override
  @internal
  @protected
  void dispose() => super.dispose();

  @override
  String toString() => 'Store(debugName: $debugName, value: $value, module: $module)';
}

extension MutateStoreExt on PipelineContext {
  void updateStore<E>(Store<E> store, E newValue) => store._update(newValue);
}
