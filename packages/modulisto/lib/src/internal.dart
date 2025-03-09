import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';

@internal
typedef RawUnit = Unit<Object?>;
@internal
typedef RawUnitIntent = UnitIntent<dynamic, Object?>;

@internal
abstract class ModuleBase implements DisposerHolder {
  void attach(covariant Attachable attachable) => attachable.attachToModule(this);

  bool get isClosed;

  @override
  abstract final Queue<FutureOr<void> Function()> $disposeQueue;
  abstract final Stream<RawUnitIntent> $intentStream;
  void $addIntent<T>(UnitIntent<T, Object?> intent);
}

@internal
abstract class UnitIntent<T, U> {
  abstract final U unit;
  abstract final T payload;
}

@internal
abstract class IntentHandler {
  @internal
  void Function(T value) $handle<T>(
    Object? intentSource,
    FutureOr<void> Function(PipelineContext context, T value) handler,
  );
}

@internal
abstract class ModuleChild {
  @internal
  ModuleBase get $module;
}

abstract class Updatable<T> {
  @internal
  void update(T update);
}

abstract class Attachable {
  @internal
  void attachToModule(ModuleBase module);
}

abstract class DisposerHolder {
  @internal
  Queue<FutureOr<void> Function()> get $disposeQueue;
}

@internal
abstract class PipelineRef implements IntentHandler, DisposerHolder {
  @override
  @internal
  Queue<FutureOr<void> Function()> get $disposeQueue;
}
