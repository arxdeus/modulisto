import 'package:pureflow/src/unit/unit.dart';

extension TriggerVoidExt on Trigger<Null> {
  void call() => $controller.add(null);
}

extension TriggerExt<T> on Trigger<T> {
  void call(T value) => $controller.add(value);
}

class Trigger<T> extends UnitBase<T> {
  Trigger(
    super.module, {
    super.debugName,
  });
}
