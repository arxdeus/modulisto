import 'package:meta/meta.dart';
import 'package:pureflow/src/interfaces.dart';
import 'package:pureflow/src/internal.dart';
import 'package:pureflow/src/unit/unit.dart';

extension MutateStore<T> on Mutator<Store<T>> {
  void set(T value) => unit._$value = value;
}

class Store<T> extends UnitBase<T> implements Mutable {
  Store(
    this._value, {
    super.debugName,
  });

  T _value;
  T get value => _value;

  @protected
  set _$value(T val) {
    $controller.add(val);
    _value = val;
  }
}
