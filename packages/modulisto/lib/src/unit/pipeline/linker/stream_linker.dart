import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';

extension StreamPipelineLinkerExt on PipelineRef {
  StreamPipelineLinker<T> stream<T>(Stream<T> stream) => StreamPipelineLinker._(stream, this);
}

class StreamPipelineLinker<T> implements PipelineLinker<Stream<T>, T>, PipelineRefHost {
  final Stream<T> _stream;

  @override
  @internal
  @protected
  final PipelineRef $pipelineRef;

  StreamPipelineLinker._(this._stream, this.$pipelineRef);

  @override
  void bind(FutureOr<void> Function(MutatorContext context, T value) handler) {
    final sub = _stream.listen($pipelineRef.$handle(_stream, handler));
    $pipelineRef.$disposeQueue.add(sub.cancel);
  }

  @override
  void redirect(FutureOr<void> Function(T value) handler) => bind((_, T value) => handler(value));
}
