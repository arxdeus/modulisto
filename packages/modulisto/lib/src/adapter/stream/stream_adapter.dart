import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';

extension UnitToStreamAdapter<T> on UnitAdapter<Unit<T>> {
  @internal
  @visibleForTesting
  static final Expando<StreamController<Object?>> $linkedControllers = Expando();

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
