import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/unit/store/value_unit_base.dart';

/// Extension for mapping a [ValueUnit] to a [MapValueUnitView].
extension MapStoreViewExt<T> on ValueUnit<T> {
  /// Maps the value of this [ValueUnit] using the provided [mapper] and returns a [MapValueUnitView].
  MapValueUnitView<N, T> map<N>(ValueMapper<N, T> mapper) => MapValueUnitView._(this, mapper);
}

/// View of a parent [ValueUnit] that listens for updates and remaps its value using a mapper function.
///
/// [value] maps lazily and caches the result until the parent value changes.
final class MapValueUnitView<T, F> extends ValueUnitBase<T> {
  /// Creates a [MapValueUnitView] with a parent [ValueUnit] and a [ValueMapper].
  MapValueUnitView._(
    this._parent,
    this._mapper, {
    super.debugName,
  }) : super(_parent.$module) {
    _parent.addListener(_setCallback);
    _cachedValue = _mappedValue;
  }

  void _setCallback(F value) => _isDirty = true;
  T get _mappedValue => _mapper(_parent.value);

  final ValueUnit<F> _parent;
  final ValueMapper<T, F> _mapper;

  late T _cachedValue;
  bool _isDirty = false;

  /// The current mapped value, recalculated only when the parent value changes.
  @override
  T get value => switch (_isDirty) {
        false => _cachedValue,
        true => _cachedValue = _mappedValue,
      };

  @override
  @internal
  @protected

  /// Disposes the view and removes its listener from the parent.
  void dispose() {
    _parent.removeListener(_setCallback);
    super.dispose();
  }
}
