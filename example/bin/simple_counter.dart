import 'package:modulisto/modulisto.dart';

final class TestModule extends Module {
  late final increment = Trigger<()>(this, debugName: 'increment');
  late final decrement = Trigger<()>(this, debugName: 'decrement');
  late final reset = Trigger<()>(this, debugName: 'reset');

  late final state = Store(this, 0, debugName: 'state');
  late final newState = Store(this, 0, debugName: 'newState');
  late final counterPipeline = Pipeline.async(
    this,
    debugName: 'counterPipeline',
    ($) => $
      ..unit(increment).bind((mutate, _) => mutate(state).patch((value) => value + 1))
      ..unit(decrement).bind((mutate, _) => mutate(state).patch((value) => value - 1))
      ..unit(reset).bind((mutate, _) => mutate(state).set(0)),
    transformer: eventTransformers.sequental,
  );

  late final _obstateObserver = Pipeline.sync(
    debugName: '_obstateObserver',
    this,
    ($) => $..unit(state).redirect(print),
  );

  TestModule() {
    Module.initialize(
      this,
      attach: {
        counterPipeline,
        _obstateObserver,
      },
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
