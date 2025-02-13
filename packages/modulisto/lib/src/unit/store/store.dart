import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/unit/unit.dart';

abstract base class Store<T> extends UnitImpl<T> implements Updatable<T>, ValueUnit<T> {
  late T _value;

  Store._(
    super.module, {
    super.debugName,
  });

  @override
  T get value => _value;

  factory Store(
    ModuleRunner module,
    T initialValue, {
    String? debugName,
  }) = _ValueStore;

  @override
  @protected
  void update(T newValue) {
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

final class _ValueStore<T> extends Store<T> {
  _ValueStore(super.module, this._value, {super.debugName}) : super._();

  @override
  // ignore: overridden_fields
  late T _value;
}
