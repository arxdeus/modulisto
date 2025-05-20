import 'package:meta/meta.dart';

import 'package:modulisto/src/unit/pipeline/pipeline_context.dart';

/// Mutation context for sync pipelines.
@internal
final class SyncPipelineContext extends PipelineContextBase {
  /// Creates a [SyncPipelineContext].
  SyncPipelineContext();

  /// Whether the context is closed and no further mutations are allowed.
  @override
  bool get isClosed => _isClosed;
  bool _isClosed = false;

  /// Disposes the context and marks it as closed.
  @override
  @mustCallSuper
  void dispose() {
    if (isClosed) return;
    _isClosed = true;
  }
}
