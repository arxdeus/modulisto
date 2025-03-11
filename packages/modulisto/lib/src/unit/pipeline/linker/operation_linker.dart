import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';
import 'package:modulisto/src/operation.dart';
import 'package:modulisto/src/settings.dart';
import 'package:modulisto/src/unit/trigger.dart';

class OperationPipelineLinker<T> implements PipelineLinker<Symbol, T> {
  final Symbol _operationId;

  @override
  @internal
  @protected
  final PipelineRef pipelineRef;

  OperationPipelineLinker(this._operationId, this.pipelineRef)
      : assert(
          T != dynamic,
          '.operationOnType<T> requires generic type for proper work',
        );

  @override
  void bind(FutureOr<void> Function(PipelineContext context, T value) handler) {
    final callback = pipelineRef.$handle(_operationId, handler);
    final moduleMap = OperationRunner.operationRunners[pipelineRef.$module] ??= {};

    (moduleMap[_operationId] ??= Trigger<Object?>(pipelineRef.$module, debugName: 'OperationTrigger($_operationId)'))
        .addListener((value) {
      if (ModulistoSettings.debugReportTypeMismatchOnOperation) {
        assert(
          value.runtimeType == T,
          'Type mismatch on Operation($_operationId), expected: $T, got: ${value.runtimeType} ',
        );
      }
      if (value.runtimeType != T) return;
      callback(value as T);
    });
  }

  @override
  void redirect(FutureOr<void> Function(T value) handler) => bind((_, T value) => handler(value));
}
