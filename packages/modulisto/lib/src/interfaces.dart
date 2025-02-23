// coverage:ignore-file

import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';

abstract class Disposable {
  FutureOr<void> dispose();
}

@internal
abstract class ModuleChild {
  @internal
  ModuleRunner get module;
}

abstract class Updatable<T> {
  @internal
  void update(T update);
}

abstract class Attachable {
  @internal
  void attachToModule(ModuleRunner module);
}

abstract class Named {
  String? get debugName;
}

@internal
@protected
abstract final class ModuleRunner {
  bool get isClosed;

  abstract final Queue<Disposable> linkedDisposables;
  abstract final Stream<RawUnitIntent> intentStream;
  void addIntent<T>(UnitIntent<T, Object?> intent);
}

typedef RawUnitIntent = UnitIntent<dynamic, Object?>;

@internal
abstract class UnitIntent<T, U> {
  abstract final U unit;
  abstract final T payload;
}

abstract base class ModuleBase implements ModuleRunner {
  void attach(covariant Attachable attachable) => attachable.attachToModule(this);

  @override
  @internal
  @protected
  @visibleForTesting
  abstract final Queue<Disposable> linkedDisposables;

  @override
  @internal
  @protected
  @visibleForTesting
  abstract final Stream<RawUnitIntent> intentStream;

  @override
  @internal
  @protected
  @visibleForTesting
  void addIntent<T>(UnitIntent<T, Object?> intent);
}

typedef ModuleLifecycle = ({
  Unit<()> init,
  Unit<()> dispose,
});
@internal
typedef RawUnit = Unit<Object?>;

abstract interface class Unit<T> implements Named, ModuleChild, ValueListenable<T>, Disposable {
  @override
  @internal
  @protected
  ModuleRunner get module;

  // coverage:ignore-end
}

abstract class ValueUnit<T> implements Unit<T> {
  T get value;
}

typedef ValueChanged<T> = void Function(T value);
typedef ValueMapper<T, F> = T Function(F value);

abstract interface class ValueListenable<T> {
  void notifyUpdate(T payload);
  void addListener(ValueChanged<T> callback);
  void removeListener(ValueChanged<T> callback);
}

abstract interface class PipelineLinker<C, T> {
  @internal
  @protected
  abstract final PipelineRef pipelineRef;

  void bind(FutureOr<void> Function(PipelineContext context, T value) handler);
  void redirect(FutureOr<void> Function(T value) handler);
}

abstract class IntentHandler {
  @internal
  void Function(T value) handle<T>(
    Object? intentSource,
    FutureOr<void> Function(PipelineContext context, T value) handler,
  );
}

abstract class PipelineRef implements IntentHandler {
  @internal
  List<void Function()> get disposers;
}

abstract interface class AsyncPipelineRef implements PipelineRef {
  @internal
  Map<Object?, List<StreamSubscription<void>>> get subscriptions;
}

abstract interface class SyncPipelineRef implements PipelineRef {}

abstract interface class PipelineContext {
  bool get isClosed;

  void update<T>(Updatable<T> updatable, T value);
}

typedef EventMapper<E> = Stream<E> Function(E value);
typedef EventTransformer = Stream<E> Function<E>(Stream<E> source, EventMapper<E> process);
