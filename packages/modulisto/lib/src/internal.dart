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

  abstract final Queue<Disposable> $linkedDisposables;
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
  ModuleBase get module;
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
  List<void Function()> get $disposers;
}

@internal
abstract class PipelineRef implements IntentHandler, DisposerHolder {}
