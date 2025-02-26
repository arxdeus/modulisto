import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';

class StreamPipelineLinker<T> implements PipelineLinker<Stream<T>, T> {
  final Stream<T> _stream;

  @override
  @internal
  @protected
  final PipelineRef pipelineRef;

  StreamPipelineLinker(this._stream, this.pipelineRef);

  @override
  void bind(FutureOr<void> Function(PipelineContext context, T value) handler) {
    final sub = _stream.listen(pipelineRef.$handle(_stream, handler));
    pipelineRef.$disposers.add(sub.cancel);
  }

  @override
  void redirect(FutureOr<void> Function(T value) handler) => bind((_, T value) => handler(value));
}
