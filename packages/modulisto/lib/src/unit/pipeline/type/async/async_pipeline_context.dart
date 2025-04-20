import 'dart:async';

import 'package:meta/meta.dart';

import 'package:modulisto/src/unit/pipeline/pipeline_context.dart';

@internal
final class AsyncPipelineContext extends PipelineContextBase {
  AsyncPipelineContext();

  @override
  bool get isClosed => _contextDeadline.isCompleted;

  late final Completer<void> _contextDeadline = Completer();
  Future<void> get future => _contextDeadline.future;

  @override
  void dispose() {
    if (!_contextDeadline.isCompleted) {
      _contextDeadline.complete();
    }
  }
}
