// coverage:ignore-file

import 'dart:async';

import 'package:meta/meta.dart';

abstract class Disposable {
  FutureOr<void> dispose();
}

@internal
abstract class ModuleChild {
  @internal
  ModuleRunner get module;
}

@internal
@protected
abstract final class ModuleRunner {
  bool get isClosed;

  abstract final List<Disposable> linkedDisposables;
  abstract final Stream<RawUnitIntent> intentStream;
  void addIntent<T>(UnitIntent<T, Stream<T>> intent);
}

typedef RawUnitIntent = UnitIntent<dynamic, Stream<dynamic>>;

@internal
abstract class UnitIntent<T, U extends Stream<T>> {
  abstract final U unit;
  abstract final T payload;
}

abstract base class ModuleBase implements ModuleRunner {
  void attach(covariant Attachable attachable) => attachable.attachToModule(this);

  @override
  @internal
  @protected
  @visibleForTesting
  abstract final List<Disposable> linkedDisposables;

  @override
  @internal
  @protected
  @visibleForTesting
  abstract final Stream<RawUnitIntent> intentStream;

  @override
  @internal
  @protected
  @visibleForTesting
  void addIntent<T>(UnitIntent<T, Stream<T>> intent);
}

typedef ModuleLifecycle = ({
  Unit<()> init,
  Unit<()> dispose,
});
@internal
typedef RawUnit = Unit<Object?>;

abstract class Attachable {
  @internal
  @protected
  void attachToModule(ModuleRunner module);
}

abstract class Named {
  String? get debugName;
}

abstract base class Unit<T> extends Stream<T> implements Named, ModuleChild, Notifiable<T>, Disposable {
  @override
  @internal
  @protected
  ModuleRunner get module;

  // coverage:ignore-start
  @override
  @internal
  @protected

  /// [last] may cause infinite awaiting for value
  Future<T> get last => super.last;
  // coverage:ignore-end
}

abstract interface class UnitHost {
  Map<Notifiable<Object?>, List<void Function(Object?)>> get listeners;
}

abstract interface class Notifiable<T> {
  void notifyUpdate(T payload);
  Set<UnitHost> get notifiableHosts;
}

abstract interface class AsyncPipelineRef {
  void bind<T>(Stream<T> stream, FutureOr<void> Function(PipelineContext context, T value) handler);
  void redirect<T>(Stream<T> stream, FutureOr<void> Function(T value) handler);
}

abstract interface class SyncPipelineRef {
  void bind<T>(Notifiable<T> unit, FutureOr<void> Function(PipelineContext context, T value) handler);
  void redirect<T>(Notifiable<T> unit, FutureOr<void> Function(T value) handler);
}

abstract interface class PipelineContext {
  bool get isClosed;
}

typedef EventMapper<Event> = Stream<Event> Function(Event value);
typedef EventTransformer = Stream<Event> Function<Event>(Stream<Event> source, EventMapper<Event> process);
