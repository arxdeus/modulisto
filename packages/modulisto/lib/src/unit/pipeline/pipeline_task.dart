// coverage:ignore-file

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/pipeline/pipeline.dart';
import 'package:modulisto/src/unit/pipeline/pipeline_context.dart';

typedef RawPipelineIntent = PipelineIntent<dynamic, Object?>;

@internal
class PipelineIntent<T, U> implements UnitIntent<T, U> {
  @override
  final U unit;
  @override
  final T payload;
  final Pipeline source;
  final FutureOr<void> Function(PipelineContext, T) task;
  final PipelineContextWithDeadline context;

  const PipelineIntent({
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
