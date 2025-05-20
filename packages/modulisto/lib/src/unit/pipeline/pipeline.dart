import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/unit/pipeline/type/async/async_pipeline.dart';
import 'package:modulisto/src/unit/pipeline/type/sync/sync_pipeline.dart';
import 'package:modulisto/src/unit/unit.dart';

typedef PipelineRegisterCallback = void Function(PipelineRef on);

/// Base class for pipeline units, implementing [Pipeline] and [Disposable].
@internal
abstract base class PipelineUnit extends UnitBase<Object?> implements Pipeline, Disposable {
  /// Creates a [PipelineUnit] with a module and optional debug name.
  PipelineUnit(
    super.module, {
    super.debugName,
  });
}

/// [Pipeline]'s handle incoming events either synchronously ([SyncPipeline]) or asynchronously ([AsyncPipeline]),
/// allowing for complex event queueing and transformation.
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
