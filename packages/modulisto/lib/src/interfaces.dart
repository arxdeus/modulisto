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

typedef ModuleLifecycle = ({
  /// [Unit] that reacts on `Module` successfull initialization
  Unit<()> init,

  /// [Unit] that reacts before `Module` dispose
  Unit<()> dispose,
});

abstract interface class Unit<T> implements Named, ModuleChild, Notifier<T>, Disposable {
  @override
  @internal
  FutureOr<void> dispose();
}

abstract class ValueUnit<T> implements Unit<T> {
  /// Currently stored value in this unit
  T get value;
}

@protected
abstract interface class Notifier<T> {
  @protected
  void notifyUpdate(T payload);
  void addListener(ValueChanged<T> callback);
  void removeListener(ValueChanged<T> callback);
}

/* Pipeline */

abstract interface class PipelineLinker<C, T> {
  /// Binds a notifies from `source` into handler callback
  /// Allow `Store` mutation via `PipelineContext` in [handler]
  void bind(FutureOr<void> Function(MutatorContext context, T value) handler);

  /// Redirects payload from `source` into handler callback
  /// Doesn't allow `Store` mutations, since no `PipelineContext` provided
  void redirect(FutureOr<void> Function(T value) handler);
}

abstract interface class MutatorContext {
  /// Whether the context is closed
  ///
  /// No any mutations will be executed using closed context
  bool get isClosed;

  Mutator<U> call<U extends Mutable>(U unit);
}

abstract interface class Mutable {}

/// Extendable adapter that allows you converter underlying [unit]
/// into other several types (`Stream`, `Listenable`, etc)
///
/// Can be reused multiple times and extended out of the main package
extension type UnitAdapter<U extends Unit<Object?>>(U unit) {}
