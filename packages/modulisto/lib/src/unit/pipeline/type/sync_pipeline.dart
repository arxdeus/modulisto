import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/pipeline/linker/stream_linker.dart';
import 'package:modulisto/src/unit/pipeline/linker/unit_linker.dart';
import 'package:modulisto/src/unit/pipeline/pipeline.dart';
import 'package:modulisto/src/unit/pipeline/pipeline_context.dart';

abstract interface class SyncPipelineRef implements PipelineRef {}

extension SyncPipelineExt on SyncPipelineRef {
  UnitPipelineLinker<T> unit<T>(Unit<T> unit) => UnitPipelineLinker(unit, this);
  StreamPipelineLinker<T> stream<T>(Stream<T> stream) => StreamPipelineLinker(stream, this);
}

@internal
final class SyncPipeline extends PipelineUnit implements SyncPipelineRef, IntentHandler {
  SyncPipeline(
    super.module,
    this.pipelineRegister, {
    super.debugName,
  });

  @override
  late final List<void Function()> disposers = [];

  @override
  void Function(T value) $handle<T>(
    Object? intentSource,
    FutureOr<void> Function(PipelineContext context, T value) handler,
  ) =>
      (T value) => handler(PipelineContextWithDeadline.create(), value);

  @override
  @protected
  void attachToModule(ModuleBase module) {
    module.$linkedDisposables.addLast(this);
    pipelineRegister(this);
  }

  @override
  void dispose() {
    for (final disposer in disposers) {
      disposer();
    }
    super.dispose();
  }

  final void Function(SyncPipelineRef pipeline) pipelineRegister;

  @override
  String toString() => 'SyncPipeline(debugName: $debugName, module: $module)';
}
