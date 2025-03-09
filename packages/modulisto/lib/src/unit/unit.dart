import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';

@internal
class SelfUnitIntent<T, U extends Stream<T>> implements UnitIntent<T, U> {
  @override
  final U unit;
  @override
  final T payload;

  const SelfUnitIntent({
    required this.unit,
    required this.payload,
  });
}

@internal
base class UnitImpl<T> implements UnitNotifier<T>, Unit<T> {
  UnitImpl(
    this.$module, {
    this.$debugName,
  }) {
    $module.$disposeQueue.addLast(dispose);
  }

  bool _isDisposed = false;
  final List<ValueChanged<T>> _listeners = [];

  @override
  @internal
  void addListener(ValueChanged<T> callback) => _listeners.add(callback);
  @override
  @internal
  void removeListener(ValueChanged<T> callback) => _listeners.remove(callback);

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
  final String? $debugName;
}
