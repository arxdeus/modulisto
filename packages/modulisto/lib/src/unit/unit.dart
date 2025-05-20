import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';

/// Defines the base for [Unit].
///
/// Provides the core notifier/listener logic for units.
@internal
base class UnitBase<T> implements Notifier<T>, Unit<T> {
  /// Creates a [UnitBase] with a module and optional debug name.
  UnitBase(
    this.$module, {
    this.debugName,
  });

  bool _isDisposed = false;
  final List<ValueChanged<T>> _listeners = [];

  /// Adds a listener to this unit. No-op if disposed.
  @override
  @internal
  void addListener(ValueChanged<T> callback) {
    if (_isDisposed) return;
    _listeners.add(callback);
  }

  /// Removes a listener from this unit. No-op if disposed.
  @override
  @internal
  void removeListener(ValueChanged<T> callback) {
    if (_isDisposed) return;
    _listeners.remove(callback);
  }

  /// Disposes the unit and clears all listeners.
  @override
  @internal
  FutureOr<void> dispose() {
    _listeners.clear();
    _isDisposed = true;
  }

  /// Notifies all listeners with the given payload, unless disposed.
  @override
  @internal
  @protected
  void notifyUpdate(T payload) {
    if (_isDisposed) return;
    for (final listener in _listeners) {
      listener(payload);
    }
  }

  /// The module this unit is bound to.
  @override
  @internal
  final ModuleBase $module;

  /// The debug name for this unit.
  @override
  @internal
  final String? debugName;
}

/// A [UnitBase] that is automatically disposed with its module
base class ModuleBindedUnitBase<T> extends UnitBase<T> {
  /// Creates a [ModuleBindedUnitBase] and binds it to the module
  ModuleBindedUnitBase(
    super.module, {
    super.debugName,
  }) {
    $module.$disposeQueue.addLast(dispose);
  }
}
