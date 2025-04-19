import 'package:modulisto/modulisto.dart';

// ignore: prefer_function_declarations_over_variables
final createModule = ({
  required EventTransformer eventTransformer,
  Duration? delayBetweenEvents,
  String? debugName,
}) =>
    TestCounter(
      debugName: debugName,
      eventTransformer: eventTransformer,
      delayBetweenEvents: delayBetweenEvents,
    );

base class TestCounter extends Module {
  TestCounter({
    required this.eventTransformer,
    this.delayBetweenEvents,
    String? debugName,
  }) {
    Module.initialize(
      this,
      debugName: debugName,
      attach: {
        _defaultPipeline,
      },
    );
  }
  late final increment = Trigger<()>(this);
  late final decrement = Trigger<()>(this);
  late final reset = Trigger<()>(this);

  late final state = Store(this, 0);
  late final stateX = Store(this, 0);

  final EventTransformer eventTransformer;

  late final _defaultPipeline = Pipeline.async(
    this,
    ($) => $
      ..unit(increment).bind(_mutateCounter((old) => old + 1))
      ..unit(decrement).bind(_mutateCounter((old) => old - 1))
      ..unit(reset).bind(_mutateCounter((old) => 0)),
    transformer: eventTransformer,
  );

  Future<void> Function(MutatorContext mutate, Object? _) _mutateCounter(
    int Function(int old) mutator,
  ) =>
      (mutate, payload) async {
        if (delayBetweenEvents != null) await Future<void>.delayed(delayBetweenEvents!);
        mutate(state).set(mutator(state.value));
      };

  final Duration? delayBetweenEvents;
}
