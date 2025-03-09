import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/operation.dart';
import 'package:modulisto/src/unit/trigger.dart';

abstract base class Module extends ModuleBase with OperationRunner implements Disposable, Named {
  static void initialize(
    Module module, {
    required Set<Attachable> attach,
  }) {
    for (final attachable in attach) {
      attachable.attachToModule(module);
    }
    module._lifecycle.init();
  }

  bool _isClosed = false;

  @override
  @internal
  @nonVirtual
  @visibleForTesting
  late final Queue<FutureOr<void> Function()> $disposeQueue = Queue();
  late final _lifecycle = (
    init: Trigger<()>(this),
    dispose: Trigger<()>(this),
  );

  @nonVirtual
  ModuleLifecycle get lifecycle => _lifecycle;

  final StreamController<RawUnitIntent> _intentController = StreamController.broadcast();

  @override
  Future<void> dispose() async {
    _lifecycle.dispose();
    _isClosed = true;

    for (final dispose in $disposeQueue) {
      await dispose();
    }
    await _intentController.close();
  }

  @override
  @internal
  @protected
  @visibleForTesting
  void $addIntent<T>(UnitIntent<T, Object?> intent) {
    if (_intentController.isClosed) return;
    _intentController.add(intent);
  }

  @override
  @internal
  Stream<RawUnitIntent> get $intentStream => _intentController.stream;

  @override
  bool get isClosed => _isClosed;

  // coverage:ignore-start
  @override
  @protected
  String? get debugName => null;

  @override
  String toString() => 'Module(debugName: $debugName, isClosed: $isClosed)';
  // coverage:ignore-end

  @override
  @protected
  @visibleForTesting
  void attach(covariant Attachable attachable) => super.attach(attachable);
}
