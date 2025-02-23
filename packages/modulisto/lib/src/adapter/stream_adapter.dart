import 'dart:async';

import 'package:modulisto/src/interfaces.dart';

extension UnitToStreamAdapter<T> on UnitAdapter<Unit<T>> {
  Stream<T> stream({
    bool emitFirstImmediately = false,
  }) {
    late final StreamController<T> controller;

    void callback(T value) => controller.add(value);
    void immediateEmitCheck() {
      if (unit is ValueUnit<T> && emitFirstImmediately) {
        controller.add((unit as ValueUnit<T>).value);
      }
    }

    controller = StreamController.broadcast(
      onListen: immediateEmitCheck,
      onCancel: () => unit.removeListener(callback),
    );

    unit.addListener(callback);
    return controller.stream;
  }
}
