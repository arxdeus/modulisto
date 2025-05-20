import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';

/// Extension to convert [UnitAdapter<Unit<T>>] into a [Stream<T>].
extension UnitToStreamAdapter<T> on UnitAdapter<Unit<T>> {
  /// Internal and visible for testing, this static Expando holds linked [StreamController]s.
  @internal
  @visibleForTesting
  static final Expando<StreamController<Object?>> $linkedControllers = Expando();

  /// Converts the [Unit] into a stream of [T] values.
  ///
  /// If the unit's module is closed, returns an empty stream.
  /// Otherwise creates/returns a broadcast stream that:
  /// - Adds value updates to the stream
  /// - Cleans up listeners when the module disposes
  Stream<T> stream() {
    if (unit.$module.isClosed) return const Stream.empty();

    final hasControllerBefore = $linkedControllers[unit] != null;
    final controller = ($linkedControllers[unit] ?? StreamController<T>.broadcast(sync: true))
        as StreamController<T>;

    if (!hasControllerBefore) {
      void callback(T value) => controller.add(value);
      $linkedControllers[unit] = controller;

      unit
        ..addListener(callback)
        ..$module.$disposeQueue.add(() {
          $linkedControllers[unit] = null;

          unit.removeListener(callback);
          unawaited(controller.close());
        });
    }

    return controller.stream;
  }
}
