import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/pipeline/type/async_pipeline.dart';
import 'package:modulisto/src/unit/pipeline/type/sync_pipeline.dart';
import 'package:modulisto/src/unit/unit.dart';

typedef PipelineRegisterCallback = void Function(PipelineRef on);

abstract class AsyncPipelineRef with PipelineRef implements Pipeline {}

abstract class SyncPipelineRef with PipelineRef implements Pipeline {}

@internal
abstract base class PipelineUnit extends UnitBase<Object?> implements Pipeline, Disposable {
  PipelineUnit(
    super.module, {
    super.debugName,
  });
}

abstract class Pipeline implements Attachable {
  /// Pipeline that handles incoming events synchronously, without any queuing mechanism
  factory Pipeline.sync(
    ModuleBase module,
    PipelineRegisterCallback pipelineRegister, {
    String? debugName,
  }) = SyncPipeline;

  /// Pipeline that transforms incoming events using [transformer]
  /// and allows to create complex event queue
  factory Pipeline.async(
    ModuleBase module,
    PipelineRegisterCallback pipelineRegister, {
    EventTransformer? transformer,
    String? debugName,
  }) = AsyncPipeline;
}
