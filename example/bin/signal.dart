import 'package:modulisto/modulisto.dart';

abstract class TestInterface {
  Future<int> someNumber(int test);
}

final class SignalModule extends Module {
  late final Trigger<({int test})> trigger = Trigger(this);
  late final store = Store(this, 0);

  Future<void> _update(PipelineContext context, ({int test}) value) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    context.update(store, value.test);
  }

  late final _syncPipeline = Pipeline.sync(this, ($) => $..unit(store).redirect(print));

  Future<int> someNumber(int test) => Operation(#someNumber, () async => test);
  Future<int> someNumber2(int test2) => Operation(#someNumber2, () async => test2);

  late final _pipeline = Pipeline.async(
    this,
    ($) => $
      ..unit(trigger).bind(_update)
      ..operationOnType<int>(#someNumber2).redirect(print),
    transformer: eventTransformers.sequental,
  );

  SignalModule() {
    Module.initialize(
      this,
      attach: {
        _syncPipeline,
        _pipeline,
      },
    );
  }
}

void main(List<String> args) async {
  ModulistoSettings.debugReportTypeMismatchOnOperation = false;

  final module = SignalModule();

  module.trigger((test: 228));

  final number = await module.someNumber2(44);
  module.trigger((test: number));
}
