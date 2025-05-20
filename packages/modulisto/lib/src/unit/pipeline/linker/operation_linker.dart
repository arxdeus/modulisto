import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/operation.dart';
import 'package:modulisto/src/settings.dart';
import 'package:modulisto/src/unit/trigger.dart';

/// Extension on [PipelineRef] allows easy binding of operations (by function) to a pipeline for event handling and type safety.
extension OperationLinkerPipelineExt on PipelineRef {
  OperationPipelineLinker<T> operationOnType<T>(Function operationId) => OperationPipelineLinker._(
        operationId,
        this,
      );
}

/// [OperationPipelineLinker] for binding `Operation`'s to `Pipeline`'
class OperationPipelineLinker<T> implements PipelineLinker<Symbol, T>, PipelineRefHost {
  final Function _sourceFunction;

  @override
  @internal
  @protected
  final PipelineRef $pipelineRef;

  OperationPipelineLinker._(this._sourceFunction, this.$pipelineRef)
      : assert(
          T != dynamic,
          '.operationOnType<T> requires generic type for proper work',
        );

  @override
  void bind(FutureOr<void> Function(MutatorContext context, T value) handler) {
    // Binds a handler to an operation, ensuring type safety and proper pipeline execution
    final callback = $pipelineRef.$handle(_sourceFunction, handler);
    final trigger = OperationRunner.$operationRunners[_sourceFunction] ??= Trigger<Object?>(
      $pipelineRef.$module,
      debugName: 'OperationTrigger(${identityHashCode(_sourceFunction).toRadixString(16)})',
    );

    // Handles operation triggers by validating type and invoking the handler
    // ignore: cascade_invocations
    trigger.addListener((value) {
      if (ModulistoSettings.debugReportOperationTypeMismatch) {
        assert(
          value.runtimeType == T,
          'Type mismatch on Operation(id: ${trigger.debugName}, source: $_sourceFunction), expected: $T, got: ${value.runtimeType} ',
        );
      }
      // Ensures type safety before invoking the handler
      if (value.runtimeType != T) return;
      callback(value as T);
    });

    // Cleans up by removing the trigger when the pipeline is disposed
    $pipelineRef.$disposeQueue.addLast(
      () => OperationRunner.$operationRunners.remove(_sourceFunction),
    );
  }

  @override
  void redirect(FutureOr<void> Function(T value) handler) => bind((_, T value) => handler(value));
}
