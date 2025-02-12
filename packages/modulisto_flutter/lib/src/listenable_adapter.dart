import 'package:flutter/foundation.dart';
import 'package:modulisto/modulisto.dart';

class ListenableAdapter implements Listenable, UnitHost {
  ListenableAdapter(this._unit);

  final Notifiable<Object?> _unit;
  late final _realListeners = <VoidCallback>[];

  @override
  @protected
  late final Map<Notifiable<Object?>, List<void Function(Object? p1)>> listeners = {};

  @override
  void addListener(VoidCallback listener) {
    if (_realListeners.isEmpty) {
      _unit.notifiableHosts.add(this);
      listeners.putIfAbsent(_unit, () => []).add((_) {
        for (final callback in _realListeners) {
          callback();
        }
      });
    }
    _realListeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _realListeners.remove(listener);
    if (_realListeners.isEmpty) {
      _unit.notifiableHosts.remove(this);
      listeners.clear();
    }
  }
}
