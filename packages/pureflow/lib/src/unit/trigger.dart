import 'package:pureflow/src/unit/unit.dart';

extension TriggerNullExt on Trigger<Null> {
  void call() => $controller.add(null);
}

extension TriggerVoidExt on Trigger<()> {
  void call() => $controller.add(());
}

extension TriggerExt<T> on Trigger<T> {
  void call(T value) => $controller.add(value);
}

class Trigger<T> extends UnitBase<T> {
  Trigger({
    super.debugName,
  });
}
