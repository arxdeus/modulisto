import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:modulisto/modulisto.dart';

/// Wrapper around [Unit] that emulates Flutter SDK [Listenable] behavior
///
/// Can be provided into `ListenableBuilder`, merged with other [Listenable]'s using [Listenable.merge]
/// or used in any other way just like an ordinary [Listenable]
class ListenableAdapter implements Listenable {
  ListenableAdapter(this._unit);

  final UnitNotifier<Object?> _unit;
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

  @internal
  void clear() {
    _realListeners.clear();
    _unit.removeListener(_callback);
  }
}
