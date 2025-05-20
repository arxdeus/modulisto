/// Provides event transformer utilities for pipelines in Modulisto.
///
/// Includes common event transformer strategies: sequential, droppable, concurrent, and restartable.
library;

// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:async';

import 'package:modulisto/modulisto.dart';
import 'package:stream_transform/stream_transform.dart';

/// Sequential event transformer: processes events one after another.
final EventTransformer _sequental = <A>(source, process) => source.asyncExpand(process);

/// Droppable event transformer: drops new events while processing the current one.
final EventTransformer _droppable =
    <A>(source, process) => source.transform(_ExhaustMapStreamTransformer<A>(process));

/// Concurrent event transformer: processes all events concurrently.
final EventTransformer _concurrent = <A>(source, process) => source.concurrentAsyncExpand(process);

/// Restartable event transformer: cancels the current process and starts a new one for each event.
final EventTransformer _restartable = <A>(source, process) => source.switchMap(process);

/// Common event transformer strategies for pipelines.
final eventTransformers = (
  sequental: _sequental,
  droppable: _droppable,
  concurrent: _concurrent,
  restartable: _restartable,
);

class _ExhaustMapStreamTransformer<T> extends StreamTransformerBase<T, T> {
  _ExhaustMapStreamTransformer(this.mapper);

  final EventMapper<T> mapper;

  @override
  Stream<T> bind(Stream<T> stream) {
    late StreamSubscription<T> subscription;
    StreamSubscription<T>? mappedSubscription;

    final controller = StreamController<T>(
      onCancel: () async {
        await mappedSubscription?.cancel();
        return subscription.cancel();
      },
      sync: true,
    );

    subscription = stream.listen(
      (data) {
        if (mappedSubscription != null) return;
        final Stream<T> mappedStream;

        mappedStream = mapper(data);
        mappedSubscription = mappedStream.listen(
          controller.add,
          onError: controller.addError,
          onDone: () => mappedSubscription = null,
        );
      },
      onError: controller.addError,
      onDone: () => mappedSubscription ?? unawaited(controller.close()),
    );

    return controller.stream;
  }
}
