import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';

extension UnitToStreamAdapter<T> on UnitAdapter<Unit<T>> {
  @internal
  @visibleForTesting
  static final Expando<StreamController<Object?>> $linkedControllers = Expando();

  Stream<T> stream() {
    if (unit.$module.isClosed) return const Stream.empty();

    final linkedController = $linkedControllers[unit] as StreamController<T>?;
    final hasControllerBefore = linkedController != null;
    final controller = linkedController ?? StreamController<T>.broadcast(sync: true);

    if (!hasControllerBefore) {
      void callback(T value) => controller.add(value);
      $linkedControllers[unit] = controller;

      unit
        ..addListener(callback)
        ..$module.$disposeQueue.add(() {
          $linkedControllers[unit] = null;

          unit.removeListener(callback);
          controller.close();
        });
    }

    return controller.stream;
  }
}
