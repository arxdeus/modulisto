import 'dart:async';

import 'package:modulisto/src/adapter/stream/closable_stream_wrapper.dart';
import 'package:modulisto/src/adapter/stream/subject.dart';
import 'package:modulisto/src/interfaces.dart';

extension ValueUnitUnitToStreamAdapter<T> on UnitAdapter<ValueUnit<T>> {
  ClosableStreamWrapper<T> stream({
    bool emitFirstImmediately = false,
  }) {
    late final StreamController<T> controller;

    void callback(T value) => controller.add(value);

    controller = emitFirstImmediately
        ? Subject<T>(
            initialValue: unit.value,
            onCancel: () => unit.removeListener(callback),
          )
        : StreamController.broadcast(
            onCancel: () => unit.removeListener(callback),
          );

    unit
      ..addListener(callback)
      ..module.$disposers.add(controller.close);
    return ClosableStreamWrapper(controller);
  }
}

extension UnitToStreamAdapter<T> on UnitAdapter<Unit<T>> {
  ClosableStreamWrapper<T> stream() {
    late final StreamController<T> controller;

    void callback(T value) => controller.add(value);

    controller = StreamController.broadcast(
      onCancel: () => unit.removeListener(callback),
    );

    unit
      ..addListener(callback)
      ..module.$disposers.add(controller.close);
    return ClosableStreamWrapper(controller);
  }
}
