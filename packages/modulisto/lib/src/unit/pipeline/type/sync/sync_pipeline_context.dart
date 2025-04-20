import 'package:meta/meta.dart';

import 'package:modulisto/src/unit/pipeline/pipeline_context.dart';

@internal
final class SyncPipelineContext extends PipelineContextBase {
  SyncPipelineContext();

  @override
  bool get isClosed => _isClosed;
  bool _isClosed = false;

  @override
  @mustCallSuper
  void dispose() {
    if (isClosed) return;
    _isClosed = true;
  }
}
