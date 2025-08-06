import 'package:meta/meta.dart';
import 'package:pureflow/src/interfaces.dart';
import 'package:pureflow/src/internal.dart';
import 'package:pureflow/src/unit/unit.dart';

extension MutateListStore<T> on Mutator<ListStore<T>> {
  void set(List<T> value) => unit.value = value;
}

class ListStore<T> extends UnitBase<List<T>> implements Mutable {
  ListStore(
    this._value, {
    super.debugName,
  });

  List<T> _value;
  List<T> get value => _value;

  @internal
  @protected
  set value(List<T> val) {
    $controller.add(val);
    _value = val;
  }
}
