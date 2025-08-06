import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pureflow/src/pipeline/pipeline_context.dart';

/// Mutation context for async pipelines.
@internal
final class AsyncPipelineContext extends PipelineContextBase {
  /// Creates an [AsyncPipelineContext].
  AsyncPipelineContext();

  late final Completer<void> _contextDeadline = Completer();

  /// Whether the context is closed and no further mutations are allowed.
  @override
  bool get isClosed => _contextDeadline.isCompleted;

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
