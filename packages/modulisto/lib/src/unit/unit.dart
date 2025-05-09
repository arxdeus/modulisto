import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';

@internal
base class UnitBase<T> implements Notifier<T>, Unit<T> {
  UnitBase(
    this.$module, {
    this.debugName,
  });

  bool _isDisposed = false;
  final List<ValueChanged<T>> _listeners = [];

  @override
  @internal
  void addListener(ValueChanged<T> callback) {
    if (_isDisposed) return;
    _listeners.add(callback);
  }

  @override
  @internal
  void removeListener(ValueChanged<T> callback) {
    if (_isDisposed) return;
    _listeners.remove(callback);
  }

  @override
  @internal
  FutureOr<void> dispose() {
    _listeners.clear();
    _isDisposed = true;
  }

  @override
  @internal
  @protected
  void notifyUpdate(T payload) {
    if (_isDisposed) return;

    for (final listener in _listeners) {
      listener(payload);
    }
  }

  @override
  @internal
  final ModuleBase $module;

  @override
  @internal
  final String? debugName;
}

base class ModuleBindedUnitBase<T> extends UnitBase<T> {
  ModuleBindedUnitBase(
    super.module, {
    super.debugName,
  }) {
    $module.$disposeQueue.addLast(dispose);
  }
}
