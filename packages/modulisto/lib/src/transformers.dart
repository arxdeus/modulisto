// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:async';

import 'package:modulisto/modulisto.dart';
import 'package:stream_transform/stream_transform.dart';

final EventTransformer _sequental = <A>(source, process) => source.asyncExpand(process);
final EventTransformer _droppable =
    <A>(source, process) => source.transform(_ExhaustMapStreamTransformer<A>(process));
final EventTransformer _concurrent = <A>(source, process) => source.concurrentAsyncExpand(process);
final EventTransformer _restartable = <A>(source, process) => source.switchMap(process);

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
