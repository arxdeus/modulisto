import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:modulisto/modulisto.dart';

/// Wrapper around [Unit] that emulates Flutter SDK [Listenable] behavior
///
/// Can be provided into `ListenableBuilder`, merged with other [Listenable]'s using [Listenable.merge]
/// or used in any other way just like an ordinary [Listenable]
class ListenableAdapter implements Listenable {
  /// Creates a [ListenableAdapter] for the given [Notifier].
  ListenableAdapter(this._unit);

  /// The underlying [Notifier] being adapted.
  final Notifier<Object?> _unit;
  late final _realListeners = <VoidCallback>[];

  @override

  /// Adds a listener callback that is triggered when the underlying [Notifier] changes state.
  void addListener(VoidCallback listener) {
    if (_realListeners.isEmpty) {
      _unit.addListener(_callback);
    }
    _realListeners.add(listener);
  }

  // This method triggers all registered callbacks when the underlying Notifier changes state.
  void _callback(_) {
    for (final callback in _realListeners) {
      callback();
    }
  }

  @override

  /// Removes a listener callback.
  void removeListener(VoidCallback listener) {
    _realListeners.remove(listener);
    if (_realListeners.isEmpty) {
      _unit.removeListener(_callback);
    }
  }

  @internal

  /// Clears all listeners and removes the callback from the underlying [Notifier].
  void clear() {
    _realListeners.clear();
    _unit.removeListener(_callback);
  }
}
