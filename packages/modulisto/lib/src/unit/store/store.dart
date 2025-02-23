import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/unit/unit.dart';

abstract base class StoreBase<T> extends UnitImpl<T> implements ValueUnit<T> {
  StoreBase(
    super.module, {
    super.debugName,
  });
}

abstract base class Store<T> extends StoreBase<T> implements Updatable<T> {
  Store._(
    super.module, {
    super.debugName,
  });

  MappedStoreView<N, T> map<N>(ValueMapper<N, T> mapper) => MappedStoreView._(this, mapper);

  factory Store(
    ModuleRunner module,
    T initialValue, {
    String? debugName,
  }) = _UpdatableStore;

  @override
  @internal
  @protected
  void dispose() => super.dispose();

  @override
  String toString() => '$runtimeType(debugName: $debugName, value: $value, module: $module)';
}

final class _UpdatableStore<T> extends Store<T> {
  _UpdatableStore(
    super.module,
    this._value, {
    super.debugName,
  }) : super._();

  @override
  @internal
  @protected
  void update(T newValue) {
    _value = newValue;
    notifyUpdate(newValue);
  }

  @override
  T get value => _value;

  late T _value;
}

final class MappedStoreView<T, F> extends StoreBase<T> {
  MappedStoreView._(
    this._parent,
    this._mapper, {
    super.debugName,
  }) : super(_parent.module) {
    _parent.addListener(_setCallback);
    _cachedValue = _mapper(_parent.value);
  }

  void _setCallback(F value) => _cachedValue = _mapper(value);

  final Store<F> _parent;
  final ValueMapper<T, F> _mapper;

  late T _cachedValue;

  @override
  T get value => _cachedValue;

  @override
  @internal
  @protected
  void dispose() {
    _parent.removeListener(_setCallback);
    super.dispose();
  }
}
