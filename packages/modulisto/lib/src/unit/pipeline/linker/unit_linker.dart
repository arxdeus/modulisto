import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/internal.dart';

class UnitPipelineLinker<T> implements PipelineLinker<Unit<T>, T> {
  final Unit<T> _unit;

  @override
  @internal
  @protected
  final PipelineRef pipelineRef;

  UnitPipelineLinker(this._unit, this.pipelineRef);

  @override
  void bind(FutureOr<void> Function(PipelineContext context, T value) handler) {
    final callback = pipelineRef.$handle(_unit, handler);
    _unit.addListener(callback);
  }

  @override
  void redirect(FutureOr<void> Function(T value) handler) => bind((_, T value) => handler(value));
}
