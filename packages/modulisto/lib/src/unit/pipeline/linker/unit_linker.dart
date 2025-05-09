import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';

extension UnitPipelineLinkerExt on PipelineRef {
  UnitPipelineLinker<T> unit<T>(Unit<T> unit) => UnitPipelineLinker._(unit, this);
}

class UnitPipelineLinker<T> implements PipelineLinker<Unit<T>, T>, PipelineRefHost {
  final Unit<T> _unit;

  @override
  @internal
  @protected
  final PipelineRef $pipelineRef;

  UnitPipelineLinker._(this._unit, this.$pipelineRef);

  @override
  void bind(FutureOr<void> Function(MutatorContext context, T value) handler) {
    final callback = $pipelineRef.$handle(_unit, handler);
    _unit.addListener(callback);
  }

  @override
  void redirect(FutureOr<void> Function(T value) handler) => bind((_, T value) => handler(value));
}
