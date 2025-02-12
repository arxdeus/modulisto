import 'dart:async';

import 'package:meta/meta.dart';
import 'package:modulisto/src/interfaces.dart';
import 'package:modulisto/src/transformers.dart';
import 'package:modulisto/src/unit/pipeline/pipeline_context.dart';
import 'package:modulisto/src/unit/pipeline/pipeline_task.dart';
import 'package:modulisto/src/unit/unit.dart';
import 'package:stream_transform/stream_transform.dart';

typedef AsyncPipelineRegisterCallback = void Function(AsyncPipelineRef $);
typedef SyncPipelineRegisterCallback = void Function(SyncPipelineRef $);

abstract class Pipeline implements Attachable {
  factory Pipeline.sync(
    ModuleRunner module,
    SyncPipelineRegisterCallback pipelineRegister, {
    String? debugName,
  }) = _SyncPipeline;

  factory Pipeline.async(
    ModuleRunner module,
    AsyncPipelineRegisterCallback pipelineRegister, {
    EventTransformer? transformer,
    String? debugName,
  }) = _AsyncPipeline;
}

sealed class _PipelineUnit extends UnitImpl<Object?> implements Pipeline, Disposable {
  _PipelineUnit(
    super.module, {
    super.debugName,
  });
}

final class _SyncPipeline extends _PipelineUnit implements SyncPipelineRef, UnitHost {
  @override
  final Map<Notifiable<Object?>, List<void Function(Object?)>> listeners = {};

  _SyncPipeline(
    super.module,
    this.pipelineRegister, {
    super.debugName,
  });

  @override
  void bind<T>(Notifiable<T> unit, void Function(PipelineContext context, T value) handler) {
    void callback(T value) => handler(PipelineContextWithDeadline.create(), value);
    listeners.putIfAbsent(unit, () => []).add((Object? value) => callback(value as T));
    unit.notifiableHosts.add(this);
  }

  @override
  void redirect<T>(Notifiable<T> unit, FutureOr<void> Function(T value) handler) =>
      bind<T>(unit, (_, T value) => handler(value));

  @override
  @protected
  void attachToModule(ModuleRunner module) {
    module.linkedDisposables.add(this);
    pipelineRegister(this);
  }

  @override
  void dispose() {
    listeners.clear();
    super.dispose();
  }

  final void Function(SyncPipelineRef pipeline) pipelineRegister;

  @override
  String toString() => 'SyncPipeline(debugName: $debugName, module: $module)';
}

final class _AsyncPipeline extends _PipelineUnit implements AsyncPipelineRef {
  _AsyncPipeline(
    super.module,
    this.pipelineRegister, {
    super.debugName,
    EventTransformer? transformer,
  }) : _transformer = transformer ?? eventTransformers.concurrent;

  final void Function(AsyncPipelineRef pipeline) pipelineRegister;
  final EventTransformer _transformer;

  late final List<Future<void>> _pendingEvents = [];
  late final Map<Stream<Object?>, List<StreamSubscription<void>>> _subscriptions = {};
  late final Stream<RawPipelineIntent> _intentStream = _transformer(
    module.intentStream.whereType<RawPipelineIntent>().where((intent) => intent.source == this),
    _handleAsyncIntent,
  );

  bool _isClosed = false;
  StreamSubscription<void>? _sub;

  @override
  @protected
  void attachToModule(ModuleRunner module) {
    pipelineRegister(this);
    _sub = _intentStream.listen(null);
    module.linkedDisposables.add(this);
  }

  @override
  @nonVirtual
  void bind<T>(Stream<T> unit, FutureOr<void> Function(PipelineContext context, T value) handler) {
    void intentCallback(T value) {
      if (_isClosed) return;
      if (module.isClosed) return;

      final context = PipelineContextWithDeadline.create();
      final intent = RawPipelineIntent(
        source: this,
        unit: unit,
        payload: value,
        task: (PipelineContext context, Object? value) => handler(context, value as T),
        context: context,
      );

      _pendingEvents.add(context.contextDeadline.future);
      module.addIntent(intent);
    }

    _subscriptions.putIfAbsent(unit, () => []).add(unit.listen(intentCallback));
  }

  @override
  void redirect<T>(covariant Stream<T> unit, FutureOr<void> Function(T value) handler) =>
      bind<T>(unit, (_, T value) => handler(value));

  @override
  @mustCallSuper
  Future<void> dispose() async {
    _isClosed = true;
    await Future.wait(_pendingEvents);
    await _sub?.cancel();

    super.dispose();
  }

  Stream<PipelineIntent<T, Stream<T>>> _handleAsyncIntent<T>(PipelineIntent<T, Stream<T>> intent) {
    if (intent.context.isClosed) return const Stream.empty();

    final controller = StreamController<PipelineIntent<T, Stream<T>>>(
      onCancel: intent.context.dispose,
      sync: true,
    );

    void removeFromPending() {
      if (_isClosed) return;
      _pendingEvents.remove(intent.context.contextDeadline.future);
    }

    Future.sync(() => intent.task(intent.context, intent.payload))
        .onError(controller.addError)
        .whenComplete(controller.close)
        .whenComplete(removeFromPending);

    return controller.stream;
  }

  @override
  String toString() => 'AsyncPipeline(debugName: $debugName, module: $module)';
}
