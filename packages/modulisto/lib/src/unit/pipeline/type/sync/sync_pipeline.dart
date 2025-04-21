import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/pipeline/pipeline.dart';
import 'package:modulisto/src/unit/pipeline/type/sync/sync_pipeline_context.dart';

abstract class SyncPipelineRef with PipelineRef implements Pipeline {}

@internal
final class SyncPipeline extends PipelineUnit implements SyncPipelineRef, IntentHandler {
  SyncPipeline(
    super.module,
    this.pipelineRegister, {
    super.debugName,
  });

  @override
  @internal
  late final Queue<void Function()> $disposeQueue = Queue();

  @override
  void Function(T value) $handle<T>(
    Object? intentSource,
    FutureOr<void> Function(MutatorContext context, T value) handler,
  ) =>
      (T value) => handler(SyncPipelineContext(), value);

  @override
  @protected
  void attachToModule(ModuleBase module) {
    pipelineRegister(this);
    $module.$disposeQueue.addLast(dispose);
  }

  @override
  void dispose() {
    for (final disposer in $disposeQueue) {
      disposer();
    }
    super.dispose();
  }

  final void Function(PipelineRef pipeline) pipelineRegister;

  @override
  String toString() => 'SyncPipeline(debugName: $debugName, module: ${$module})';
}
