// coverage:ignore-file

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/internal.dart';

/// Defines a callback that is called whenever a value changes in a unit.
typedef ValueChanged<T> = void Function(T value);

/// Defines a function that maps one type to another using a custom mapper.
typedef ValueMapper<T, F> = T Function(F value);

/// Defines a function that transforms an event stream into another event stream.
typedef EventMapper<E> = Stream<E> Function(E value);

/// Defines a function that transforms a source stream into a result stream
/// by applying the given event mapper.
typedef EventTransformer = Stream<E> Function<E>(Stream<E> source, EventMapper<E> process);

/// An interface that represents an object that can be disposed of.
abstract class Disposable {
  /// Disposes of this object and frees up any resources it is using.
  FutureOr<void> dispose();
}

/// Defines the lifecycle events for a module.
typedef ModuleLifecycle = ({
  /// A callback function that is called when the module is initialized.
  Unit<()> init,

  /// A callback function that is called before the module is disposed.
  Unit<()> dispose,
});

/// An interface that represents a unit with a named and disposable behavior.
abstract interface class Unit<T> implements Named, ModuleChild, Notifier<T>, Disposable {
  @override
  @internal
  FutureOr<void> dispose();
}

/// An abstract interface for units that maintain a value.
abstract interface class ValueUnit<T> implements Unit<T> {
  /// The current value stored in the unit.
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

/// An abstract interface that allows linking notifications from a source into handlers.
abstract interface class PipelineLinker<C, T> {
  /// Binds notifications from `source` into the handler callback,
  /// allowing for mutations through `PipelineContext` in [handler].
  void bind(FutureOr<void> Function(MutatorContext context, T value) handler);

  /// Redirects payload from `source` into the handler callback,
  /// not allowing mutations since no `PipelineContext` is provided.
  void redirect(FutureOr<void> Function(T value) handler);
}

/// An abstract interface for contexts that provide mutation capabilities.
abstract interface class MutatorContext {
  /// Indicates whether the context is closed and prevents any further mutations.
  bool get isClosed;

  /// Provides a mutable unit by calling [call].
  Mutator<U> call<U extends Mutable>(U unit);
}

/// An abstract interface representing a mutable unit.
abstract interface class Mutable {}

/// Extends an underlying [unit] to allow conversions into different types (e.g., streams, listenables).
///
/// Can be reused multiple times and extended out of the main package.
extension type UnitAdapter<U extends Unit<Object?>>(U unit) {}
