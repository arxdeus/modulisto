import 'dart:async';

import 'package:modulisto/modulisto.dart';

final class TestModule extends Module {
  @override
  String get debugName => 'Test';

  late final increment = Trigger<()>(this, debugName: 'increment');
  late final decrement = Trigger<()>(this, debugName: 'decrement');
  late final reset = Trigger<()>(this, debugName: 'reset');

  late final state = Store(this, 0, debugName: 'state');
  late final newState = Store(this, 0, debugName: 'newState');
  late final counterPipeline = Pipeline.async(
    this,
    debugName: 'counterPipeline',
    ($) => $
      ..bind(increment, _changeValue(() => state.value + 1, state))
      ..bind(decrement, _changeValue(() => state.value - 1, state))
      ..bind(reset, _changeValue(() => 0, state)),
    transformer: eventTransformers.sequental,
  );

  late final _obstateObserver = Pipeline.sync(
    debugName: '_obstateObserver',
    this,
    ($) => $..redirect(state, print),
  );

  Future<void> Function(PipelineContext, Object? _) _changeValue(int Function() mutator, Store<int> state) =>
      (context, _) async {
        await Future<void>.delayed(const Duration(milliseconds: 350));
        if (context.isClosed) return;

        context.updateStore(state, mutator());
      };

  TestModule() {
    Module.initialize(
      this,
      ($) => $
        ..attach(counterPipeline)
        ..attach(_obstateObserver),
    );
  }
}

void main(List<String> args) async {
  final x = TestModule();
  x.increment();
  x.increment();

  await x.dispose();

  // no reset? T_T
  x.reset();
}
