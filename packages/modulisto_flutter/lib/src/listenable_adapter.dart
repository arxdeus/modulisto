import 'package:flutter/foundation.dart';
import 'package:modulisto/modulisto.dart' as modulisto;

class ListenableAdapter implements Listenable {
  ListenableAdapter(this._unit);

  final modulisto.ValueListenable<Object?> _unit;
  late final _realListeners = <VoidCallback>[];

  @override
  void addListener(VoidCallback listener) {
    if (_realListeners.isEmpty) {
      _unit.addListener(_callback);
    }
    _realListeners.add(listener);
  }

  void _callback(_) {
    for (final callback in _realListeners) {
      callback();
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    _realListeners.remove(listener);
    if (_realListeners.isEmpty) {
      _unit.removeListener(_callback);
    }
  }
}
