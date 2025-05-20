import 'dart:async';

import 'package:meta/meta.dart';

import 'package:modulisto/src/unit/pipeline/pipeline_context.dart';

/// Mutation context for async pipelines.
@internal
final class AsyncPipelineContext extends PipelineContextBase {
  /// Creates an [AsyncPipelineContext].
  AsyncPipelineContext();

  /// Whether the context is closed and no further mutations are allowed.
  @override
  bool get isClosed => _contextDeadline.isCompleted;

  late final Completer<void> _contextDeadline = Completer();

  /// A [Future] that completes when the context is closed.
  Future<void> get future => _contextDeadline.future;

  /// Disposes the context and completes the context deadline.
  @override
  void dispose() {
    if (!_contextDeadline.isCompleted) {
      _contextDeadline.complete();
    }
  }
}
