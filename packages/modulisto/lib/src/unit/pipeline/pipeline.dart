import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/unit/pipeline/type/async_pipeline.dart';
import 'package:modulisto/src/unit/pipeline/type/sync_pipeline.dart';
import 'package:modulisto/src/unit/unit.dart';

typedef AsyncPipelineRegisterCallback = void Function(AsyncPipelineRef $);
typedef SyncPipelineRegisterCallback = void Function(SyncPipelineRef $);

@internal
abstract base class PipelineUnit extends UnitImpl<Object?> implements Pipeline, Disposable {
  PipelineUnit(
    super.module, {
    super.debugName,
  });
}

abstract class Pipeline implements Attachable {
  factory Pipeline.sync(
    ModuleRunner module,
    SyncPipelineRegisterCallback pipelineRegister, {
    String? debugName,
  }) = SyncPipeline;

  factory Pipeline.async(
    ModuleRunner module,
    AsyncPipelineRegisterCallback pipelineRegister, {
    EventTransformer? transformer,
    String? debugName,
  }) = AsyncPipeline;
}
