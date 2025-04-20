// coverage:ignore-file

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/pipeline/pipeline.dart';
import 'package:modulisto/src/unit/pipeline/type/async/async_pipeline_context.dart';

typedef RawAsyncPipelineIntent = AsyncPipelineIntent<dynamic, Object?>;

@internal
class AsyncPipelineIntent<T, U> implements UnitIntent<T, U> {
  @override
  final U unit;
  @override
  final T payload;

  final Pipeline source;
  final FutureOr<void> Function(MutatorContext, T) task;
  final AsyncPipelineContext context;

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
