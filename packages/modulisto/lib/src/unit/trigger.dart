import 'package:meta/meta.dart';
import 'package:modulisto/src/unit/unit.dart';

extension TriggerVoidCallExt on Trigger<()> {
  /// Invokes a trigger with empty payload
  void call() => notifyUpdate(());
}

extension TriggerPayloadCallExt<T> on Trigger<T> {
  /// Invokes a trigger with [payload] of type [T]
  void call(T payload) => notifyUpdate(payload);
}

/// A subtype of the Unit that represents a unary (synchronous) call.
///
/// When the `.call` method is invoked (with the appropriate `payload` of type `T`)
/// it notifies all `Unit` `listeners` with new value
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
