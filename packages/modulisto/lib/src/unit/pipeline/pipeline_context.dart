import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';

@internal
final class PipelineContext implements MutatorContext, Disposable {
  PipelineContext();

  Completer<void>? _contextDeadline;
  Completer<void>? get contextDeadline => switch (_contextDeadline) {
        Completer<void>() => _contextDeadline,
        _ when !_isClosed => _contextDeadline ??= Completer(),
        _ => null,
      };

  @override
  bool get isClosed => _contextDeadline?.isCompleted ?? _isClosed;

  bool _isClosed = false;

  @override
  void dispose() {
    if (isClosed) return;
    _isClosed = true;
    _contextDeadline?.complete();
  }

  @override
  Mutator<M> call<M extends Mutable>(M unit) => Mutator(unit);
}
