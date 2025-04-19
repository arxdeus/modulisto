import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/unit/unit.dart';

abstract base class StoreBase<T> extends UnitBase<T> implements ValueUnit<T> {
  StoreBase(
    super.$module, {
    super.debugName,
  });
}
