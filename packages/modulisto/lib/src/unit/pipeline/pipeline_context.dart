import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';

@internal
final class PipelineContextWithDeadline implements PipelineContext, Disposable {
  PipelineContextWithDeadline.create();

  final Completer<void> contextDeadline = Completer();

  @override
  bool get isClosed => contextDeadline.isCompleted;
  @override
  void dispose() {
    if (contextDeadline.isCompleted) return;
    contextDeadline.complete();
  }
}
