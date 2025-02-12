import 'package:meta/meta.dart';
import 'package:modulisto/src/unit/unit.dart';

extension TriggerVoidCallExt on Trigger<()> {
  void call() => notifyUpdate(());
}

extension TriggerPayloadCallExt<T> on Trigger<T> {
  void call(T payload) => notifyUpdate(payload);
}

final class Trigger<T> extends UnitImpl<T> {
  Trigger(
    super.module, {
    super.debugName,
  });

  @override
  @internal
  @protected
  void notifyUpdate(T payload) => super.notifyUpdate(payload);

  @override
  String toString() => 'Trigger(debugName: $debugName, module: $module)';
}
