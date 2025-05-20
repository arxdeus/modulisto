// coverage:ignore-file

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/pipeline/pipeline.dart';
import 'package:modulisto/src/unit/pipeline/type/async/async_pipeline_context.dart';

/// Type alias for a raw async pipeline intent.
typedef RawAsyncPipelineIntent = AsyncPipelineIntent<dynamic, Object?>;

/// Intent object for async pipelines.
@internal
class AsyncPipelineIntent<T, U> implements UnitIntent<T, U> {
  /// The unit associated with this intent.
  @override
  final U unit;

  /// The payload for this intent.
  @override
  final T payload;

  /// The source pipeline for this intent.
  final Pipeline source;

  /// The task to execute for this intent.
  final FutureOr<void> Function(MutatorContext, T) task;

  /// The async pipeline context for this intent.
  final AsyncPipelineContext context;

  /// Creates an [AsyncPipelineIntent] with the given unit, payload, source, task, and context.
  const AsyncPipelineIntent({
    required this.unit,
    required this.payload,
    required this.source,
    required this.task,
    required this.context,
  });

  @override
  String toString() =>
      'PipelineIntent(unit: $unit, payload: $payload, source: $source, task: $task, context: $context)';
}
