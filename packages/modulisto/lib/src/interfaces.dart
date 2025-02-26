// coverage:ignore-file

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/internal.dart';

typedef ValueChanged<T> = void Function(T value);
typedef ValueMapper<T, F> = T Function(F value);

typedef EventMapper<E> = Stream<E> Function(E value);
typedef EventTransformer = Stream<E> Function<E>(Stream<E> source, EventMapper<E> process);

abstract class Disposable {
  FutureOr<void> dispose();
}

abstract class Named {
  /// [debugName] will appear in logs instead of [runtimeType]
  String? get debugName;
}

typedef ModuleLifecycle = ({
  /// [Unit] that reacts on `Module` successfull initialization
  Unit<()> init,

  /// [Unit] that reacts before `Module` dispose
  Unit<()> dispose,
});

abstract interface class Unit<T> implements Named, ModuleChild, UnitNotifier<T>, Disposable {
  @override
  @internal
  ModuleBase get module;

  @override
  @internal
  FutureOr<void> dispose();
}

abstract class ValueUnit<T> implements Unit<T> {
  /// Currently stored value in this unit
  T get value;
}

@protected
abstract interface class UnitNotifier<T> {
  @protected
  void notifyUpdate(T payload);
  void addListener(ValueChanged<T> callback);
  void removeListener(ValueChanged<T> callback);
}

/* Pipeline */

abstract interface class PipelineLinker<C, T> {
  @internal
  @protected
  abstract final PipelineRef pipelineRef;

  /// Binds a notifies from `source` into handler callback
  /// Allow `Store` mutation via `PipelineContext` in [handler]
  void bind(FutureOr<void> Function(PipelineContext context, T value) handler);

  /// Redirects payload from `source` into handler callback
  /// Doesn't allow `Store` mutations, since no `PipelineContext` provided
  void redirect(FutureOr<void> Function(T value) handler);
}

abstract interface class PipelineContext {
  /// Whether the context is closed
  ///
  /// No any mutations will be executed using closed context
  bool get isClosed;

  /// Updates passed [updatable] (at the current moment, only `Store`) to the new [value]
  ///
  /// Does nothing if context was closed (read about [isClosed])
  void update<T>(Updatable<T> updatable, T value);
}

/// Extendable adapter that allows you converter underlying [unit]
/// into other several types (`Stream`, `Listenable`, etc)
///
/// Can be reused multiple times and extended out of the main package
extension type UnitAdapter<U extends Unit<Object?>>(U unit) {}
