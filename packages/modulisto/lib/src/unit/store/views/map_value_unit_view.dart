import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/unit/store/store.dart';
import 'package:modulisto/src/unit/store/value_unit_base.dart';

extension MapStoreViewExt<T> on ValueUnit<T> {
  MapValueUnitView<N, T> map<N>(ValueMapper<N, T> mapper) => MapValueUnitView._(this, mapper);
}

/// View of `parent` [Store] that listen for it updates and remaps `value` using `mapper` function
///
/// Value maps lazily, that means that first read of updated [value] will execute `mapper` function and cache the result
/// If the [value] of underlying (parent) [Store] was changed, then newcoming read will execute `mapper` again and cache value.
/// No unneccessary mapper execution at all, only on first read of [.value]
final class MapValueUnitView<T, F> extends ValueUnitBase<T> {
  MapValueUnitView._(
    this._parent,
    this._mapper, {
    super.debugName,
  }) : super(_parent.$module) {
    _parent.addListener(_setCallback);
    _cachedValue = _mapper(_parent.value);
  }

  void _setCallback(F value) => _cachedValue = _mapper(value);

  final ValueUnit<F> _parent;
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
