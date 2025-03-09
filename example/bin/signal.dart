import 'package:modulisto/modulisto.dart';

final class SignalModule extends Module {
  late final Trigger<({int test})> trigger = Trigger(this);
  late final store = Store(this, 0);

  Future<void> _update(PipelineContext context, ({int test}) value) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    context.update(store, value.test);
  }

  late final _syncPipeline = Pipeline.sync(this, ($) => $..unit(store).redirect(print));

  late final _pipeline = Pipeline.async(
    this,
    ($) => $..unit(trigger).bind(_update),
    transformer: eventTransformers.sequental,
  );

  SignalModule() {
    Module.initialize(
      this,
      debugName: 'test',
      attach: {
        _syncPipeline,
        _pipeline,
      },
    );
  }
}

void main(List<String> args) async {
  final module = SignalModule();
  print(module);
  module.trigger((test: 228));
  module.trigger((test: 229));
  module.trigger((test: 240));
  module.trigger((test: 230));
  await module.dispose();
  module.trigger((test: 999));
  module.trigger((test: 1));
}
