import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/pipeline/pipeline.dart';
import 'package:modulisto/src/unit/pipeline/type/sync/sync_pipeline_context.dart';

/// Reference interface for synchronous pipelines.
abstract class SyncPipelineRef with PipelineRef implements Pipeline {}

/// Synchronous pipeline implementation.
///
/// Handles synchronous event processing and mutation context management.
@internal
final class SyncPipeline extends PipelineUnit implements SyncPipelineRef, IntentHandler {
  /// Creates a [SyncPipeline] with the given module, register callback, and optional debug name.
  SyncPipeline(
    super.module,
    this.pipelineRegister, {
    super.debugName,
  });

  @override
  @internal
  late final Queue<void Function()> $disposeQueue = Queue();

  /// Handles events synchronously using a [SyncPipelineContext].
  @override
  void Function(T value) $handle<T>(
    Object? intentSource,
    FutureOr<void> Function(MutatorContext context, T value) handler,
  ) =>
      (T value) => handler(SyncPipelineContext(), value);

  /// Attaches the [Pipeline] to the module and registers it.
  @override
  @protected
  void attachToModule(ModuleBase module) {
    pipelineRegister(this);
    $module.$disposeQueue.addLast(dispose);
  }

  /// Disposes the pipeline and its resources.
  @override
  void dispose() {
    for (final disposer in $disposeQueue) {
      disposer();
    }
    super.dispose();
  }

  /// The register callback for this pipeline.
  final void Function(PipelineRef pipeline) pipelineRegister;

  @override
  String toString() => 'SyncPipeline(debugName: $debugName, module: ${$module})';
}
