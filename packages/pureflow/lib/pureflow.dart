import 'package:pureflow/src/interfaces.dart';
import 'package:pureflow/src/module.dart';
import 'package:pureflow/src/pipeline/linker/stream_linker.dart';
import 'package:pureflow/src/pipeline/pipeline.dart';
import 'package:pureflow/src/unit/store.dart';
import 'package:pureflow/src/unit/trigger.dart';

void main() {
  final dummy = DummyModule();
  dummy.increment();
  dummy.increment();
  dummy.increment();
  dummy.increment();
  dummy.increment();
  Future.delayed(
    Duration(seconds: 2),
    dummy.decrement.call,
  );
}

final class DummyModule extends Module {
  late final increment = Trigger<Null>(this);
  late final decrement = Trigger<Null>(this);

  late final state = Store<int>(this, 0);

  void _updateCounter(MutatorContext mutate, int value) =>
      mutate(state).set(state.value + value);

  late final _pipeline = Pipeline.sync(
    this,
    (on) => on
      ..stream(state).redirect(print)
      ..stream(increment).bind(
        (context, value) => _updateCounter(context, 1),
      )
      ..stream(decrement).bind(
        (context, value) => _updateCounter(context, -1),
      ),
  );

  DummyModule() {
    run(
      attach: {_pipeline},
    );
  }
}
