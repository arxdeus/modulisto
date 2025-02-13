import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';

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
base class UnitImpl<T> extends Stream<T> implements Notifiable<T>, Unit<T> {
  UnitImpl(
    this.module, {
    this.debugName,
  });

  bool _isDisposed = false;
  bool _isAsynchronous = false;

  @override
  @internal
  @protected
  late final Set<UnitHost> notifiableHosts = {};

  @override
  void dispose() {
    _isDisposed = true;
    for (final host in notifiableHosts) {
      host.listeners.remove(this);
    }
    notifiableHosts.clear();
  }

  @override
  @internal
  @protected
  void notifyUpdate(T payload) {
    if (_isDisposed) return;

    for (final host in notifiableHosts) {
      final listeners = host.listeners[this];
      if (listeners == null) return;

      for (final callback in listeners) {
        callback(payload);
      }
    }

    if (!_isAsynchronous) return;
    if (module.isClosed) return;

    Future(
      () => module.addIntent(
        SelfUnitIntent(
          unit: this,
          payload: payload,
        ),
      ),
    );
  }

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    if (!_isAsynchronous) _isAsynchronous = true;

    return module.intentStream
        .where((intent) => intent is SelfUnitIntent && intent.unit == this)
        .map((intent) => intent.payload as T)
        .listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        );
  }

  @override
  @internal
  final ModuleRunner module;

  @override
  final String? debugName;
}
