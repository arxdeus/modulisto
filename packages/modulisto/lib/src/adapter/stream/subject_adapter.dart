import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/adapter/stream/subject.dart';
import 'package:modulisto/src/interfaces.dart';



/// Converts [UnitAdapter<ValueUnit<T>>] to a stream of values
extension ValueUnitUnitToStreamAdapter<T> on UnitAdapter<ValueUnit<T>> {
  /// Tracks linked controllers for each unit to manage lifecycle
  @internal
  @visibleForTesting
  static final Expando<Subject<dynamic>> linkedControllers = Expando();

  /// Returns a stream of values from the unit
  ///
  /// If the unit's module is closed, returns an empty stream.
  /// Otherwise creates/returns a subject stream that:
  /// - Adds value updates to the stream
  /// - Cleans up listeners when the module disposes
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
