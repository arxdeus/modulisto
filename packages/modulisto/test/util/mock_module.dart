import 'package:modulisto/modulisto.dart';

// ignore: prefer_function_declarations_over_variables
final createModule = ({
  required EventTransformer eventTransformer,
  Duration? delayBetweenEvents,
}) =>
    TestCounter(
      eventTransformer: eventTransformer,
      delayBetweenEvents: delayBetweenEvents,
    );

base class TestCounter extends Module {
  TestCounter({
    required this.eventTransformer,
    this.delayBetweenEvents,
  }) {
    Module.initialize(
      this,
      attach: {
        _defaultPipeline,
      },
    );
  }
  late final increment = Trigger<()>(this);
  late final decrement = Trigger<()>(this);
  late final reset = Trigger<()>(this);

  late final state = Store(this, 0);

  final EventTransformer eventTransformer;

  late final _defaultPipeline = Pipeline.async(
    this,
    ($) => $
      ..bind(increment, _mutateCounter((old) => old + 1))
      ..bind(decrement, _mutateCounter((old) => old - 1))
      ..bind(reset, _mutateCounter((old) => 0)),
    transformer: eventTransformer,
  );

  Future<void> Function(PipelineContext context, Object? _) _mutateCounter(int Function(int old) mutator) =>
      (context, payload) async {
        if (delayBetweenEvents != null) await Future<void>.delayed(delayBetweenEvents!);
        context.update(state, mutator(state.value));
      };

  final Duration? delayBetweenEvents;
}
