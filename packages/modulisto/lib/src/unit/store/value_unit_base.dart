import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/unit/unit.dart';

abstract base class ValueUnitBase<T> extends ModuleBindedUnitBase<T> implements ValueUnit<T> {
  ValueUnitBase(
    super.module, {
    super.debugName,
  });
}
