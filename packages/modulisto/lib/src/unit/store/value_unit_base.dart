import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/unit/unit.dart';

/// Abstract base class for value-holding units.
abstract base class ValueUnitBase<T> extends ModuleBindedUnitBase<T> implements ValueUnit<T> {
  /// Creates a [ValueUnitBase] with an optional debug name.
  ValueUnitBase(
    super.module, {
    super.debugName,
  });
}
