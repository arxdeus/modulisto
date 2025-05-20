import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/transformers.dart';
import 'package:modulisto/src/unit/pipeline/pipeline.dart';
import 'package:modulisto/src/unit/pipeline/type/async/async_pipeline_context.dart';
import 'package:modulisto/src/unit/pipeline/type/async/async_pipeline_intent.dart';
import 'package:stream_transform/stream_transform.dart';

abstract class AsyncPipelineRef with PipelineRef implements Pipeline {}

@internal
final class AsyncPipeline extends PipelineUnit implements AsyncPipelineRef, IntentHandler {
  /// Creates an [AsyncPipeline] with the given module, register callback, and optional debug name.
  AsyncPipeline(
    super.module,
    this.pipelineRegister, {
    super.debugName,
    EventTransformer? transformer,
  }) : _transformer = transformer ?? eventTransformers.concurrent;

  final void Function(PipelineRef pipeline) pipelineRegister;
  final EventTransformer _transformer;

  /// List of pending event futures for this pipeline.
  late final List<Future<void>> _pendingEvents = [];

  /// The dispose queue for this pipeline.
  @override
  @internal
  late final Queue<void Function()> $disposeQueue = Queue();

  /// The stream of raw async pipeline intents for this pipeline.
  late final Stream<RawAsyncPipelineIntent> _intentStream = _transformer(
    $module.$intentStream
        .whereType<RawAsyncPipelineIntent>()
        .where((intent) => intent.source == this),
    _handleAsyncIntent,
  );

  bool _isClosed = false;
  StreamSubscription<void>? _sub;

  /// Attaches the pipeline to the module and registers it.
  @override
  @protected
  void attachToModule(ModuleBase module) {
    pipelineRegister(this);
    _sub = _intentStream.listen(null);
    module.$disposeQueue.addFirst(dispose);
  }

  /// Handles events asynchronously using an [AsyncPipelineContext].
  @override
  void Function(T value) $handle<T>(
    Object? intentSource,
    FutureOr<void> Function(MutatorContext context, T value) handler,
  ) {
    void intentCallback(T value) {
      if (_isClosed) return;
      if ($module.isClosed) return;

      final context = AsyncPipelineContext();
      final intent = RawAsyncPipelineIntent(
        source: this,
        unit: intentSource,
        payload: value,
        task: (MutatorContext context, Object? value) => handler(context, value as T),
        context: context,
      );

      _pendingEvents.add(context.future);
      $module.$addIntent(intent);
    }

    return intentCallback;
  }

  /// Disposes the pipeline and its resources.
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

  Stream<AsyncPipelineIntent<T, Object?>> _handleAsyncIntent<T>(
    AsyncPipelineIntent<T, Object?> intent,
  ) {
    if (intent.context.isClosed) return const Stream.empty();

    final controller = StreamController<AsyncPipelineIntent<T, Object?>>(
      onCancel: intent.context.dispose,
      sync: true,
    );

    void removeFromPending() {
      if (_isClosed) return;
      _pendingEvents.remove(intent.context.future);
    }

    Future.sync(() => intent.task(intent.context, intent.payload))
        .onError(controller.addError)
        .whenComplete(controller.close)
        .whenComplete(removeFromPending);

    return controller.stream;
  }

  @override
  String toString() => 'AsyncPipeline(debugName: $debugName, module: ${$module})';
}
