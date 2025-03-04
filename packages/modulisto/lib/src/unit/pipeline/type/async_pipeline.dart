import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/transformers.dart';
import 'package:modulisto/src/unit/pipeline/linker/stream_linker.dart';
import 'package:modulisto/src/unit/pipeline/linker/unit_linker.dart';
import 'package:modulisto/src/unit/pipeline/pipeline.dart';
import 'package:modulisto/src/unit/pipeline/pipeline_context.dart';
import 'package:modulisto/src/unit/pipeline/pipeline_task.dart';
import 'package:stream_transform/stream_transform.dart';

abstract interface class AsyncPipelineRef implements PipelineRef {}

extension AsyncPipelineExt on AsyncPipelineRef {
  UnitPipelineLinker<T> unit<T>(Unit<T> unit) => UnitPipelineLinker(unit, this);
  StreamPipelineLinker<T> stream<T>(Stream<T> stream) => StreamPipelineLinker(stream, this);
}

@internal
final class AsyncPipeline extends PipelineUnit implements AsyncPipelineRef, IntentHandler {
  AsyncPipeline(
    super.module,
    this.pipelineRegister, {
    super.debugName,
    EventTransformer? transformer,
  }) : _transformer = transformer ?? eventTransformers.concurrent;

  final void Function(AsyncPipelineRef pipeline) pipelineRegister;
  final EventTransformer _transformer;

  late final List<Future<void>> _pendingEvents = [];
  @override
  @internal
  late final Queue<void Function()> $disposeQueue = Queue();

  late final Stream<RawPipelineIntent> _intentStream = _transformer(
    module.$intentStream.whereType<RawPipelineIntent>().where((intent) => intent.source == this),
    _handleAsyncIntent,
  );

  bool _isClosed = false;
  StreamSubscription<void>? _sub;

  @override
  @protected
  void attachToModule(ModuleBase module) {
    pipelineRegister(this);
    _sub = _intentStream.listen(null);
    module.$disposeQueue.addFirst(dispose);
  }

  @override
  void Function(T value) $handle<T>(
    Object? intentSource,
    FutureOr<void> Function(PipelineContext context, T value) handler,
  ) {
    void intentCallback(T value) {
      if (_isClosed) return;
      if (module.isClosed) return;

      final context = PipelineContextWithDeadline.create();
      final intent = RawPipelineIntent(
        source: this,
        unit: intentSource,
        payload: value,
        task: (PipelineContext context, Object? value) => handler(context, value as T),
        context: context,
      );

      _pendingEvents.add(context.contextDeadline.future);
      module.$addIntent(intent);
    }

    return intentCallback;
  }

  @override
  @mustCallSuper
  Future<void> dispose() async {
    _isClosed = true;
    await Future.wait(_pendingEvents);
    await _sub?.cancel();

    for (final disposer in $disposeQueue) {
      disposer();
    }
    super.dispose();
  }

  Stream<PipelineIntent<T, Object?>> _handleAsyncIntent<T>(PipelineIntent<T, Object?> intent) {
    if (intent.context.isClosed) return const Stream.empty();

    final controller = StreamController<PipelineIntent<T, Object?>>(
      onCancel: intent.context.dispose,
      sync: true,
    );

    void removeFromPending() {
      if (_isClosed) return;
      _pendingEvents.remove(intent.context.contextDeadline.future);
    }

    Future.sync(() => intent.task(intent.context, intent.payload))
        .onError(controller.addError)
        .whenComplete(controller.close)
        .whenComplete(removeFromPending);

    return controller.stream;
  }

  @override
  String toString() => 'AsyncPipeline(debugName: $debugName, module: $module)';
}
