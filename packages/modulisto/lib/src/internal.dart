import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';

@internal
abstract class Named {
  /// [debugName] will appear in logs instead of [runtimeType]
  String? get debugName;
}

/// A raw unit type.
@internal
typedef RawUnit = Unit<Object?>;

/// A raw unit intent type.
@internal
typedef RawUnitIntent = UnitIntent<dynamic, Object?>;

/// An abstract class representing a module base that implements the DisposeQueue interface.
@internal
abstract class ModuleBase implements DisposeQueue {
  /// Attaches an attachable to the module.
  void attach(covariant Attachable attachable) => attachable.attachToModule(this);

  /// Returns whether the module is closed.
  bool get isClosed;

  /// The dispose queue for the module.
  @override
  abstract final Queue<FutureOr<void> Function()> $disposeQueue;

  /// The intent stream for the module.
  abstract final Stream<RawUnitIntent> $intentStream;

  /// Adds an intent to the module.
  void $addIntent<T>(UnitIntent<T, Object?> intent);
}

/// An abstract class representing a unit intent with a unit and payload.
@internal
abstract class UnitIntent<T, U> {
  /// The unit for the intent.
  abstract final U unit;

  /// The payload for the intent.
  abstract final T payload;
}

/// An abstract class representing an intent handler that can handle intents.
@internal
abstract class IntentHandler {
  @internal
  void Function(T value) $handle<T>(
    Object? intentSource,
    FutureOr<void> Function(MutatorContext context, T value) handler,
  );
}

/// An abstract class representing a module child that has a module reference.
@internal
abstract class ModuleChild {
  /// The module reference for the module child.
  @internal
  ModuleBase get $module;
}

/// An abstract class representing an updatable object with an update method.
abstract class Updatable<T> {
  /// Updates the object with the given update.
  @internal
  void update(T update);
}

/// An abstract class representing an attachable that can be attached to a module.
abstract class Attachable {
  /// Attaches the attachable to the module.
  @internal
  void attachToModule(ModuleBase module);
}

/// An abstract interface for dispose queues.
abstract class DisposeQueue {
  /// The dispose queue for the object.
  @internal
  Queue<FutureOr<void> Function()> get $disposeQueue;
}

/// A mixin that provides pipeline reference functionality to a module child, intent handler, and dispose queue.
@internal
mixin PipelineRef implements ModuleChild, IntentHandler, DisposeQueue {
  /// The module reference for the pipeline ref.
  @override
  @internal
  ModuleBase get $module;

  /// The dispose queue for the pipeline ref.
  @override
  @internal
  Queue<FutureOr<void> Function()> get $disposeQueue;
}

/// An abstract class that represents a pipeline ref host with a pipeline reference.
@internal
abstract class PipelineRefHost {
  /// The pipeline reference for the pipeline ref host.
  PipelineRef get $pipelineRef;
}

/// An extension type that provides access to the mutation functions of a unit.
@internal
extension type Mutator<M extends Mutable>(M _unit) {
  /// Returns the unit of the mutable object.
  @internal
  M get unit => _unit;
}
