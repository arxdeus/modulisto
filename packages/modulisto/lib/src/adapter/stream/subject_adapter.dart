import 'package:meta/meta.dart';
import 'package:modulisto/src/adapter/stream/subject.dart';
import 'package:modulisto/src/interfaces.dart';

extension ValueUnitUnitToStreamAdapter<T> on UnitAdapter<ValueUnit<T>> {
  @internal
  @visibleForTesting
  static final Expando<Subject<dynamic>> linkedControllers = Expando();

  Stream<T> subject() {
    if (unit.module.isClosed) return const Stream.empty();
    final linkedController = linkedControllers[unit] as Subject<T>?;
    final hasControllerBefore = linkedController != null;
    final Subject<T> controller = linkedController ?? Subject(initialValue: unit.value);

    if (!hasControllerBefore) {
      void callback(T value) => controller.add(value);
      linkedControllers[unit] = controller;

      unit
        ..addListener(callback)
        ..module.$disposeQueue.add(() {
          linkedControllers[unit] = null;
          unit.removeListener(callback);
          controller.close();
        });
    }

    return controller.stream;
  }
}
