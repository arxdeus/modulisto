import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/adapter/stream/subject.dart';
import 'package:modulisto/src/interfaces.dart';

extension ValueUnitUnitToStreamAdapter<T> on UnitAdapter<ValueUnit<T>> {
  @internal
  @visibleForTesting
  static final Expando<Subject<dynamic>> linkedControllers = Expando();

  Stream<T> subject() {
    if (unit.$module.isClosed) return const Stream.empty();
    final hasControllerBefore = linkedControllers[unit] != null;
    final controller =
        (linkedControllers[unit] ?? Subject<T>(initialValue: unit.value)) as Subject<T>;

    if (!hasControllerBefore) {
      void callback(T value) => controller.add(value);
      linkedControllers[unit] = controller;

      unit
        ..addListener(callback)
        ..$module.$disposeQueue.add(() {
          linkedControllers[unit] = null;
          unit.removeListener(callback);
          unawaited(controller.close());
        });
    }

    return controller.stream;
  }
}
