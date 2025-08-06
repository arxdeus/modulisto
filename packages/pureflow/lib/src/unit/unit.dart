import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pureflow/src/core/sync_stream.dart';
import 'package:pureflow/src/interfaces.dart';

abstract class UnitBase<T> with Stream<T> implements Unit<T> {
  @override
  final String? debugName;

  @internal
  @nonVirtual
  final SyncStreamController<T> $controller = SyncStreamController();

  UnitBase({
    this.debugName,
  });

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      $controller.stream.listen(
        onData,
      );
}
